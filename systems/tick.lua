local concord = require("lib.concord")
local components = require("components")
local tick = concord.system({"beards", components.life, components.beard}, {"blinkers", components.life, components.blink}, {"walkers", components.actor, components.pose}, {"outfitTogglers", components.toggleOutfit}, {"objects", components.integrity}, {"mortals", components.life}, {"corpses", components.death})

function tick:update()
	local rng = self:getInstance().rng
	
	for i = 1, self.beards.size do
		local beard = self.beards:get(i):get(components.beard)
		beard.current = math.min(beard.current + 1, beard.maximum)
		if beard.current == beard.maximum then beard.impact = 1 else beard.impact = 0 end
	end
	for i = 1, self.blinkers.size do
		local blink = self.blinkers:get(i):get(components.blink)
		blink.current = (blink.current + 1) % blink.speed * blink.modifier
		if blink.current < blink.length / blink.modifier then blink.impact = 1 else blink.impact = 0 end
	end
	for i = 1, self.walkers.size do
		local e = self.walkers:get(i)
		local actor, pose = e:get(components.actor), e:get(components.pose)
		if pose.walkStages then
			if actor.actions.x ~= 0 or actor.actions.y ~= 0 then
				pose.moved = true
				pose.walkTimer = (pose.walkTimer + actor.actions.speedMultiplier) % pose.walkLoopSpeed
				pose.impact = pose.walkStart + math.floor(pose.walkTimer / pose.walkFrameTime) - 1
			elseif pose.moved then
				pose.moved = false
				pose.walkTimer = 0
				pose.current = "stand"
				pose.impact = pose.byName["stand"]
			end
		end
	end
	for i = 1, self.outfitTogglers.size do
		local e = self.outfitTogglers:get(i)
		local toggleOutfit = e:get(components.toggleOutfit)
		local actor = e:get(components.actor)
		toggleOutfit.toggling = toggleOutfit.toggling * (actor.actions.toggleOutfit and -1 or 1)
		local tiredness = e:get(components.tiredness)
		if tiredness and math.abs(toggleOutfit.state) ~= toggleOutfit.timeRequired / 2 then
			tiredness.current = tiredness.current + toggleOutfit.cost
			toggleOutfit.impact = (math.sgn(toggleOutfit.state) + 1) / 2
		end
		toggleOutfit.state = math.min(math.max(-toggleOutfit.timeRequired / 2, toggleOutfit.state + toggleOutfit.toggling), toggleOutfit.timeRequired / 2)
	end
	
	for i = 1, self.objects.size do
		local e = self.objects:get(i)
		local integrity = e:get(components.integrity)
		integity.current = math.max(integrity.current, 0)
		local broken = integrity.current == 0 and true or false
		
		integrity.broken = broken
		
		local light = e:get(components.light)
		if light then
			light.on = not broken
		end
	end
	
	for i = 1, self.mortals.size do
		local e = self.mortals:get(i)
		local damage = e:get(components.damageable)
		if damage.current > damage.endurance then -- TODO: make it more complex, yeah?
			local pose = e:get(components.pose)
			if pose then
				local choices = pose.deaths and pose.deaths[damage[type]]
				if choices then
					pose.current = choices[rng:random(#choices)]
				end
			end
			local blink = e:get(components.blink)
			if blink then
				blink.current, blink.impact = 0, 1
			end
			e:remove(components.life):give(components.death):apply()
		end
	end
end

return tick