-- Mach 5 CSP Physics Script - Main Module
-- Authored by ohyeah2389

DEBUG = false

local JumpJacks = require('jumpjacks')

Sim = ac.getSim() or {}
Data = ac.accessCarPhysics() or {}
Physics = ac.getCarPhysics(car.index) or {}
Shared = ac.connect({
    ac.StructItem.key('mach5'),
    jumpJackPosFront = ac.StructItem.float(),
    jumpJackPosRear = ac.StructItem.float(),
}, true, ac.SharedNamespace.CarDisplay)

local jumpJackSystem = JumpJacks({
    jacks = {
        frontLeft = {
            length = 1.1,
            baseForce = 60000,
            springCoef = 1000,
            frictionCoef = 14,
            position = vec3(-0.545, 0.18, 0.77)
        },
        frontRight = {
            length = 1.1,
            baseForce = 60000,
            springCoef = 1000,
            frictionCoef = 14,
            position = vec3(0.545, 0.18, 0.77)
        },
        rearLeft = {
            length = 1.2,
            baseForce = 70000,
            springCoef = 1000,
            frictionCoef = 14,
            position = vec3(-0.45, 0.18, -0.73)
        },
        rearRight = {
            length = 1.2,
            baseForce = 70000,
            springCoef = 1000,
            frictionCoef = 14,
            position = vec3(0.45, 0.18, -0.73)
        }
    }
})

function script.reset()
    jumpJackSystem:reset()
end

ac.onCarJumped(0, script.reset)

function script.update(dt)
    jumpJackSystem:update({
        frontLeft = car.extraA,
        frontRight = car.extraA,
        rearLeft = car.extraA,
        rearRight = car.extraA
    }, dt)

    Shared.jumpJackPosFront = -(jumpJackSystem.jacks.frontLeft.physicsObject.position + jumpJackSystem.jacks.frontRight.physicsObject.position) / 2
    Shared.jumpJackPosRear = -(jumpJackSystem.jacks.rearLeft.physicsObject.position + jumpJackSystem.jacks.rearRight.physicsObject.position) / 2
end
