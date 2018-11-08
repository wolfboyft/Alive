local concord = require("lib.concord")
local systems = require("systems")
local components = require("components")
local behaviours = require("behaviours")
local hc = require("lib.hc")
local reregisterShapes, unregisterShapes = require("util.reregisterShapes"), require("util.unregisterShapes")
local core = require("const.core")
local dirt = require("util.toppingDirt")

return function(theme, width, height, rng, length, time)
	length = length or core.speed * 60 * 60 -- an hour
	time = time or length /  2 -- midday
	local realm = concord.instance()
	realm.width, realm.height = width, height
	realm.dayLength = length
	realm.time = time
	realm.collider = hc.new(core.terrainScale)
	realm.rng = rng -- All realms have a copy of the RNG so that they can allow their systems access to it via getInstance()
	
	function realm:placePatch(generatorBehaviour, x, y, radius, quantity)
		for i = 1, quantity do
			local radius, angle = radius * self.rng:random(), self.rng:random() * tau
			local x, y = x + math.cos(angle) * radius, y + math.sin(angle) * radius
			table.insert(entities, behaviours.generator(self, x, y))
		end
	end
	
	function realm:getLightLevel()
		local sunLight = (math.tri(self.time / self.dayLength * math.tau - math.tau / 4) + 1) / 2
		sunLight = sunLight * 0.75 + 0.125
		return sunLight, sunLight, sunLight
	end
	
	realm.bedrockNoiseInfo, realm.bedrockR, realm.bedrockG, realm.bedrockB = {0.5, 0.5, -0.2, 1}, 0.55, 0.4, 0.35
	realm.onEntityAdded, realm.onEntityRemoved = reregisterShapes, unregisterShapes
	local tiles = {}
	for x = 0, realm.width - 1 do
		local column = {}
		tiles[x] = column
		for y = 0, realm.height - 1 do
			local newTile = behaviours.tile(concord.entity(), x, y, realm)
			local topping = dirt.new(rng)
			newTile:get(components.tile).topping = topping
			topping:growGrass()
			column[y] = newTile
			-- realm:addEntity(newTile)
		end
	end
	
	realm.tiles = tiles
	local temp = behaviours.femaleHuman(concord.entity(), 1536, 1536, 0, realm)
	temp:get(components.actor).player = "aliveplayer"
	temp:give(components.camera, "aliveplayer")
	realm
		:addSystem(systems.preact(), "update")
		:addSystem(systems.clean(), "update")
		:addSystem(systems.realmTransfers(), "update")
		:addSystem(systems.build(), "update")
		:addSystem(systems.move(), "update")
		:addSystem(systems.collide(), "update")
		:addSystem(systems.tick(), "update")
		:addSystem(systems.updateViewSectors(), "update")
		:addSystem(systems.see(), "draw")
		:addEntity(temp)
	return realm
end