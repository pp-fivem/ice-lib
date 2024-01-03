--thx https://github.com/overextended/ox_lib/blob/master/resource/zoneCreator/client.lua

local points = {}
local displayMode = 1
local creatorActive = false
local controlsActive = false
local minCheck = steps[1][1] / 2
local alignMovementWithCamera = false
local displayModes = { 'basic', 'walls', 'axes', 'full' }
local step, xCoord, yCoord, zCoord, heading, height, width, length
local steps = { { 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10, 25, 50, 100 }, { 0.25, 0.5, 1, 2.5, 5, 15, 30, 45, 60, 90, 180 } }

local function firstToUpper(str)
    return (str:gsub('^%l', string.upper))
end

local function updateText()
    local text = {
        ('------ Creating BOX Zone ------  \n'),
        ('Step size [Scroll]: %sm/%s&deg;  \n'):format(steps[1][step], steps[2][step]),
        ('X coord [A/D]: %s  \n'):format(xCoord),
        ('Y coord [W/S]: %s  \n'):format(yCoord),
        ('Z coord [R/F]: %s  \n'):format(zCoord),
        ('Heading [Q/E]: %s&deg;  \n'):format(heading),
        ('Height [Shift + Scroll]: %s  \n'):format(height),
        ('Width [Ctrl + Scroll]: %s  \n'):format(width),
        ('Length [Alt + Scroll]: %s  \n'):format(length),
        ('Cycle display mode [G]: %s  \n'):format(firstToUpper(displayModes[displayMode])),
        ('Toggle Axis mode [C]: %s  \n'):format(alignMovementWithCamera and 'Camera' or 'Grid'),
        'Recenter - [Space]  \n',
        'Toggle controls - [X]  \n',
        'Save - [Enter]  \n',
        'Cancel - [Esc]'
    }

    lib.showTextUI(table.concat(text))
end

local function round(number)
    return number >= 0 and math.floor(number + 0.5) or math.ceil(number - 0.5)
end

local function drawRectangle(rec)
    DrawPoly(rec[1].x, rec[1].y, rec[1].z, rec[2].x, rec[2].y, rec[2].z, rec[3].x, rec[3].y, rec[3].z, 255, 42, 24, 100)
    DrawPoly(rec[2].x, rec[2].y, rec[2].z, rec[1].x, rec[1].y, rec[1].z, rec[3].x, rec[3].y, rec[3].z, 255, 42, 24, 100)
    DrawPoly(rec[1].x, rec[1].y, rec[1].z, rec[4].x, rec[4].y, rec[4].z, rec[3].x, rec[3].y, rec[3].z, 255, 42, 24, 100)
    DrawPoly(rec[4].x, rec[4].y, rec[4].z, rec[1].x, rec[1].y, rec[1].z, rec[3].x, rec[3].y, rec[3].z, 255, 42, 24, 100)
end

local function drawLines()
    local thickness = vec(0, 0, height / 2)

    for i = 1, #points do
        points[i] = vec(points[i].x, points[i].y, zCoord)
        local a = points[i] + thickness
        local b = points[i] - thickness
        local c = (points[i + 1] and vec(points[i + 1].x, points[i + 1].y, zCoord) or points[1]) + thickness
        local d = (points[i + 1] and vec(points[i + 1].x, points[i + 1].y, zCoord) or points[1]) - thickness
        local e = points[i]
        local f = (points[i + 1] and vec(points[i + 1].x, points[i + 1].y, zCoord) or points[1])

        DrawLine(a.x, a.y, a.z, b.x, b.y, b.z, 255, 42, 24, 225)
        DrawLine(a.x, a.y, a.z, c.x, c.y, c.z, 255, 42, 24, 225)
        DrawLine(b.x, b.y, b.z, d.x, d.y, d.z, 255, 42, 24, 225)
        DrawLine(e.x, e.y, e.z, f.x, f.y, f.z, 255, 42, 24, 225)

        if displayMode == 2 or displayMode == 4 then
            drawRectangle({ a, b, d, c })
        end
    end
end

local function getRelativePos(origin, point, theta)
    if theta == 0.0 then return point end
    local p = point - origin
    local pX, pY = p.x, p.y
    theta = math.rad(theta)
    local cosTheta = math.cos(theta)
    local sinTheta = math.sin(theta)
    local x = math.floor(((pX * cosTheta - pY * sinTheta) + origin.x) * 100 + 0.0) / 100
    local y = math.floor(((pX * sinTheta + pY * cosTheta) + origin.y) * 100 + 0.0) / 100
    return x, y
end

local isFivem = cache.game == 'fivem'
local controls = {
    ['INPUT_LOOK_LR'] = 1 or 0xA987235F,
    ['INPUT_LOOK_UD'] = isFivem and 2 or 0xD2047988,
    ['INPUT_MP_TEXT_CHAT_ALL'] = isFivem and 245 or 0x9720FCEE
}

function Ice.startCreator()
    creatorActive = true
    controlsActive = true

    step = 5
    local coords = GetEntityCoords(cache.ped)
    xCoord = round(coords.x) + 0.0
    yCoord = round(coords.y) + 0.0
    zCoord = round(coords.z) + 0.0
    heading = 0.0
    height = 4.0
    width = 4.0
    length = 4.0
    local canceled = false
    points = {}

    updateText()

    while creatorActive do
        Wait(0)

        if IsDisabledControlJustReleased(0, 73) then -- x
            controlsActive = not controlsActive
        end

        if displayMode == 3 or displayMode == 4 then
            if alignMovementWithCamera then
                local rightX, rightY = getRelativePos(vec2(xCoord, yCoord), vec2(xCoord + 2, yCoord),
                    GetGameplayCamRot(2).z)
                local forwardX, forwardY = getRelativePos(vec2(xCoord, yCoord), vec2(xCoord, yCoord + 2),
                    GetGameplayCamRot(2).z)

                DrawLine(xCoord, yCoord, zCoord, rightX, rightY or 0, zCoord, 0, 255, 0, 225)
                DrawLine(xCoord, yCoord, zCoord, forwardX, forwardY or 0, zCoord, 0, 255, 0, 225)
            end

            DrawLine(xCoord, yCoord, zCoord, xCoord + 2, yCoord, zCoord, 0, 0, 255, 225)
            DrawLine(xCoord, yCoord, zCoord, xCoord, yCoord + 2, zCoord, 0, 0, 255, 225)
            DrawLine(xCoord, yCoord, zCoord, xCoord, yCoord, zCoord + 2, 0, 0, 255, 225)
        end

        local rad = math.rad(-heading)
        local sinH = math.sin(rad)
        local cosH = math.cos(rad)
        local center = vec2(xCoord, yCoord)
        ---@type vector2[]
        points = {
            center + vec2((width * cosH + length * sinH), (length * cosH - width * sinH)) / 2,
            center + vec2(-(width * cosH - length * sinH), (length * cosH + width * sinH)) / 2,
            center + vec2(-(width * cosH + length * sinH), -(length * cosH - width * sinH)) / 2,
            center + vec2((width * cosH - length * sinH), -(length * cosH + width * sinH)) / 2,
        }

        drawLines()


        if controlsActive then
            DisableAllControlActions(0)
            EnableControlAction(0, controls['INPUT_LOOK_LR'], true)
            EnableControlAction(0, controls['INPUT_LOOK_UD'], true)
            EnableControlAction(0, controls['INPUT_MP_TEXT_CHAT_ALL'], true)

            local change = false
            local lStep = steps[1][step]
            local rStep = steps[2][step]

            if IsDisabledControlJustReleased(0, 17) then -- scroll up
                if IsDisabledControlPressed(0, 21) then  -- shift held down
                    change = true
                    height += lStep
                elseif IsDisabledControlPressed(0, 36) then -- ctrl held down
                    change = true
                    width += lStep
                elseif IsDisabledControlPressed(0, 19) then -- alt held down
                    change = true
                    length += lStep
                elseif step < 11 then
                    change = true
                    step += 1
                end
            elseif IsDisabledControlJustReleased(0, 16) then -- scroll down
                if IsDisabledControlPressed(0, 21) then      -- shift held down
                    change = true

                    if height - lStep > lStep then
                        height -= lStep
                    elseif height - lStep > 0 then
                        height = lStep
                    end
                elseif IsDisabledControlPressed(0, 36) then -- ctrl held down
                    change = true

                    if width - lStep > lStep then
                        width -= lStep
                    elseif width - lStep > 0 then
                        width = lStep
                    end
                elseif IsDisabledControlPressed(0, 19) then -- alt held down
                    change = true

                    if length - lStep > lStep then
                        length -= lStep
                    elseif length - lStep > 0 then
                        length = lStep
                    end
                elseif step > 1 then
                    change = true
                    step -= 1
                end
            elseif IsDisabledControlJustReleased(0, 32) then -- w
                change = true

                if alignMovementWithCamera then
                    local newX, newY = getRelativePos(vec2(xCoord, yCoord), vec2(xCoord, yCoord + lStep),
                        GetGameplayCamRot(2).z)

                    if math.abs(newX) < minCheck then
                        newX = 0.0
                    end

                    if newY == nil or math.abs(newY) < minCheck then
                        newY = 0.0
                    end

                    xCoord = newX
                    yCoord = newY
                else
                    local newValue = yCoord + lStep

                    if math.abs(newValue) < minCheck then
                        newValue = 0.0
                    end

                    yCoord = newValue
                end
            elseif IsDisabledControlJustReleased(0, 33) then -- s
                change = true

                if alignMovementWithCamera then
                    local newX, newY = getRelativePos(vec2(xCoord, yCoord), vec2(xCoord, yCoord - lStep),
                        GetGameplayCamRot(2).z)

                    if math.abs(newX) < minCheck then
                        newX = 0.0
                    end

                    if newY == nil or math.abs(newY) < minCheck then
                        newY = 0.0
                    end

                    xCoord = newX
                    yCoord = newY
                else
                    local newValue = yCoord - lStep

                    if math.abs(newValue) < minCheck then
                        newValue = 0.0
                    end

                    yCoord = newValue
                end
            elseif IsDisabledControlJustReleased(0, 35) then -- d
                change = true

                if alignMovementWithCamera then
                    local newX, newY = getRelativePos(vec2(xCoord, yCoord), vec2(xCoord + lStep, yCoord),
                        GetGameplayCamRot(2).z)

                    if math.abs(newX) < minCheck then
                        newX = 0.0
                    end

                    if newY == nil or math.abs(newY) < minCheck then
                        newY = 0.0
                    end

                    xCoord = newX
                    yCoord = newY
                else
                    local newValue = xCoord + lStep

                    if math.abs(newValue) < minCheck then
                        newValue = 0.0
                    end

                    xCoord = newValue
                end
            elseif IsDisabledControlJustReleased(0, 34) then -- a
                change = true

                if alignMovementWithCamera then
                    local newX, newY = getRelativePos(vec2(xCoord, yCoord), vec2(xCoord - lStep, yCoord),
                        GetGameplayCamRot(2).z)

                    if math.abs(newX) < minCheck then
                        newX = 0.0
                    end

                    if newY == nil or math.abs(newY) < minCheck then
                        newY = 0.0
                    end

                    xCoord = newX
                    yCoord = newY
                else
                    local newValue = xCoord - lStep

                    if math.abs(newValue) < minCheck then
                        newValue = 0.0
                    end

                    xCoord = newValue
                end
            elseif IsDisabledControlJustReleased(0, 45) then -- r
                change = true
                local newValue = zCoord + lStep

                if math.abs(newValue) < minCheck then
                    newValue = 0.0
                end

                zCoord = newValue
            elseif IsDisabledControlJustReleased(0, 23) then -- f
                change = true
                local newValue = zCoord - lStep

                if math.abs(newValue) < minCheck then
                    newValue = 0.0
                end

                zCoord = newValue
            elseif IsDisabledControlJustReleased(0, 38) then -- e
                change = true
                heading -= rStep

                if heading < 0 then
                    heading += 360
                end
            elseif IsDisabledControlJustReleased(0, 44) then -- q
                change = true
                heading += rStep

                if heading >= 360 then
                    heading -= 360
                end
            elseif IsDisabledControlJustReleased(0, 47) then -- g
                change = true

                if displayMode == #displayModes then
                    displayMode = 1
                else
                    displayMode += 1
                end
            elseif IsDisabledControlJustReleased(0, 26) then -- c
                change = true
                alignMovementWithCamera = not alignMovementWithCamera
            elseif IsDisabledControlJustReleased(0, 22) then -- space
                change = true

                coords = GetEntityCoords(cache.ped)
                xCoord = round(coords.x)
                yCoord = round(coords.y)
            elseif IsDisabledControlJustReleased(0, 201) then -- enter
                creatorActive = false
                controlsActive = false
                lib.hideTextUI()
            elseif IsDisabledControlJustReleased(0, 200) then -- esc
                SetPauseMenuActive(false)
                creatorActive = false
                controlsActive = false
                lib.hideTextUI()

                canceled = true
            end

            if change then
                updateText()
            end
        end
    end

    return canceled and false or {
        coords = vec3(xCoord, yCoord or 0.0, zCoord),
        size = vec3(width, length, height),
        rotation = heading
    }
end
