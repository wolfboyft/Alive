constants = {}

constants.speedOfPlay = 30 -- How many ticks in a second.
constants.slownessOfPlay = 1 / constants.speedOfPlay -- How long a tick should be in seconds.
constants.viewportX = 0
constants.viewportY = 0
constants.viewportWidth = 384
constants.viewportHeight = 256
constants.screenWidth = 384
constants.screenHeight = 256
constants.up, constants.right, constants.down, constants.left = 0, 1, 2, 3 -- In terms of angles in spritesheets
local recorded, unrecorded = 1, 2
constants.recorded, constants.unrecorded = recorded, unrecorded
constants.inputs = {
	forwards = recorded, strafeLeft = recorded, backwards = recorded, strafeRight = recorded, turnLeft = recorded, turnRight = recorded, use = recorded, run = recorded, duck = recorded, sneak = recorded, act = recorded,
	pause = recorded, screenshot = recorded, scaleUp = recorded, scaleDown = recorded, toggleFullscreen = recorded, toggleInfo = recorded-- TODO: Figure out the demo system. If there is a quick record button et cetera it goes here.
}
constants.takenDamage = 1
constants.turnFraction = 32 -- tau / this = maximum turning per tick for an animal
constants.ground = 0
constants.pit = 1
constants.liquid = 2
constants.window = 3
constants.wall = 4
constants.falloffStart = 120
constants.targetRadius = 240
constants.terrainScale = 12 -- How many pixels per tile drawing?
constants.unitsPerTile = constants.terrainScale ^ 3 -- how many voxels in a tile?
constants.pixelsPerMetre = 16
constants.angles = 4
constants.pusheePenalty = 3 -- Higher values make pushing entities' immovability decrease more during calculation
constants.tileBorderSize = 1.5
constants.constituentCount = 5
constants.constituentQuantityStages = 8
constants.twilightEtc = true -- Without this, midnight is pitch black (0) and midday is full white (1). With it, the day and night cycle goes between 0.125 and 0.875.

return constants
