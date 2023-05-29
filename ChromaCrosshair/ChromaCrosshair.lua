-- Created by ArtzHarvest - https://aimware.net/forum/user/484354

callbacks.Register("Draw", function()
    local maxColorValue = 255
    local speed = 1

    local counter = 1
    if counter <= maxColorValue then
        local r = math.floor(math.sin(globals.RealTime() * speed) * 127 + 128)
        local g = math.floor(math.sin(globals.RealTime() * speed + 2) * 127 + 128)
        local b = math.floor(math.sin(globals.RealTime() * speed + 4) * 127 + 128)

        client.SetConVar("cl_crosshaircolor_r", r, true)
        client.SetConVar("cl_crosshaircolor_g", g, true)
        client.SetConVar("cl_crosshaircolor_b", b, true)

        counter = counter + 1
    end
    if counter == maxColorValue then
        counter = 1
    end
end)