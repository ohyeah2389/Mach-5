-- Mach 5 CSP Graphics Script
-- Authored by ohyeah2389

local sharedData = ac.connect({
    ac.StructItem.key('mach5'),
    jumpJackPosFront = ac.StructItem.float(),
    jumpJackPosRear = ac.StructItem.float(),
}, true, ac.SharedNamespace.CarDisplay) -- Remember to connect new items in script.lua and to update every instance of sharedData in every script in /extension

local light_headlight_left = ac.accessCarLight("LIGHT_HEADLIGHT_1")
local light_headlight_right = ac.accessCarLight("LIGHT_HEADLIGHT_2")

local jumpJackFrontObj = ac.findNodes("JumpJack_Front")
local jumpJackRearObj = ac.findNodes("JumpJack_Rear")

local jumpJackFrontObj_initialPosition = jumpJackFrontObj:getPosition()
local jumpJackRearObj_initialPosition = jumpJackRearObj:getPosition()

local eveningEyeSwingBlend = 0
local lightFadeout = 0

---@diagnostic disable-next-line: duplicate-set-field
function script.update(dt)
    ac.boostFrameRate()

    eveningEyeSwingBlend = math.lerp(eveningEyeSwingBlend, 0, dt * 4)
    lightFadeout = math.lerp(lightFadeout, (car.headlightsActive and not car.extraE) and 1 or 0, dt * (car.extraE and 1 or 15))

    local eveningEyeSwing = math.lerp((math.sin(sim.time * 0.015) * 0.07) + 0.0, -0.04, eveningEyeSwingBlend)

    if car.extraE then
        light_headlight_left.color = rgb(1, 0.12, 0.1)
        light_headlight_left.singleFrequency = 1
        light_headlight_left.intensity = 30 * (1 - lightFadeout)
        light_headlight_left.rangeGradientOffset = 0.5
        light_headlight_left.secondSpotIntensity = 0.1
        light_headlight_left.secondSpot = 50
        light_headlight_left.spot = 12
        light_headlight_left.spotSharpness = 0.7
        light_headlight_left.direction = vec3(0, 0, 1):rotate(quat.fromAngleAxis(eveningEyeSwing, vec3(0, 1, 0)))

        light_headlight_right.color = rgb(1, 0.12, 0.1)
        light_headlight_right.singleFrequency = 1
        light_headlight_right.intensity = 30 * (1 - lightFadeout)
        light_headlight_right.rangeGradientOffset = 0.5
        light_headlight_right.secondSpotIntensity = 0.1
        light_headlight_right.secondSpot = 50
        light_headlight_right.spot = 12
        light_headlight_right.spotSharpness = 0.7
        light_headlight_right.direction = vec3(0, 0, 1):rotate(quat.fromAngleAxis(-eveningEyeSwing, vec3(0, 1, 0)))
    else
        light_headlight_left.color = rgb(1, 0.9, 0.8)
        light_headlight_left.singleFrequency = 0
        light_headlight_left.intensity = 7 * lightFadeout
        light_headlight_left.rangeGradientOffset = 0.2
        light_headlight_left.secondSpotIntensity = 0.2
        light_headlight_left.secondSpot = 160
        light_headlight_left.spot = 30
        light_headlight_left.spotSharpness = 0.2
        light_headlight_left.direction = vec3(0.1, 0, 1)

        light_headlight_right.color = rgb(1, 0.9, 0.8)
        light_headlight_right.singleFrequency = 0
        light_headlight_right.intensity = 7 * lightFadeout
        light_headlight_right.rangeGradientOffset = 0.2
        light_headlight_right.secondSpotIntensity = 0.2
        light_headlight_right.secondSpot = 160
        light_headlight_right.spot = 30
        light_headlight_right.spotSharpness = 0.2
        light_headlight_right.direction = vec3(-0.1, 0, 1)
    end

    ac.debug("jumpJackFrontObj_initialPosition", jumpJackFrontObj_initialPosition)
    ac.debug("jumpJackRearObj_initialPosition", jumpJackRearObj_initialPosition)

    ac.debug("sharedData.jumpJackPosFront", sharedData.jumpJackPosFront)
    ac.debug("sharedData.jumpJackPosRear", sharedData.jumpJackPosRear)

    jumpJackFrontObj:setPosition(vec3(jumpJackFrontObj_initialPosition.x, jumpJackFrontObj_initialPosition.y + sharedData.jumpJackPosFront, jumpJackFrontObj_initialPosition.z))
    jumpJackRearObj:setPosition(vec3(jumpJackRearObj_initialPosition.x, jumpJackRearObj_initialPosition.y + sharedData.jumpJackPosRear, jumpJackRearObj_initialPosition.z))
end
