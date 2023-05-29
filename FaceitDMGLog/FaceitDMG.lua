--updater by m0nsterJ
local local_version = "1.0"
---@diagnostic disable-next-line: undefined-global
local local_script_name = GetScriptName()
local github_version_url = "https://raw.githubusercontent.com/ArtzHarvest/AimwareLuas/main/FaceitDMGLog/versions.txt"
local github_version = http.Get(github_version_url)
local github_source_url = "https://raw.githubusercontent.com/ArtzHarvest/AimwareLuas/main/FaceitDMGLog/FaceitDMG.lua"

if local_version ~= tostring(github_version) then
    print("Now updating " ..local_script_name)
    file.Delete(local_script_name)
    print("Successfully deleted old version of " ..local_script_name)
    file.Write(local_script_name, http.Get(github_source_url))
    local_version = github_version
    print("Successfully updated " ..local_script_name)
---@diagnostic disable-next-line: undefined-global
    UnloadScript(local_script_name)
end

--took ffi funktions from FFIChatVoteReveal.lua
local CHudChat_Printf_Index = 27
local ChatPrefix = "\02[\07AW\02] "
local function FindHudElement(name)
    local m_Table = mem.FindPattern("client.dll", "B9 ?? ?? ?? ?? 68 ?? ?? ?? ?? E8 ?? ?? ?? ?? 89 46 24")
    local m_Function = mem.FindPattern("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39")

    if m_Table ~= nil and m_Function ~= nil then
        return ffi.cast("void*(__thiscall*)(void*, const char*)", m_Function)(ffi.cast("void**", m_Table + 0x1)[0], name)
    end

    return nil
end
local CHudChat = FindHudElement("CHudChat")
if CHudChat == nil then
    error("CHudChat is nullptr.")
end
local CHudChat_Printf = ffi.cast("void(__cdecl*)(void*, int, int, const char*, ...)", ffi.cast("void***", CHudChat)[0][CHudChat_Printf_Index])
local function ChatPrint(msg)
    CHudChat_Printf(CHudChat, 0, 0, " " .. ChatPrefix .. msg)
end

-- Created by ArtzHarvest - https://aimware.net/forum/user/484354
local playerDamage = {}
local localPlayerIndex = client.GetLocalPlayerIndex()
callbacks.Register("FireGameEvent", "EventHook", function(e)
    local eventName = e:GetName()
    if eventName == 'round_announce_match_start' then
        playerDamage = {}
    end
    if eventName == "player_hurt" then
        local attacker = entities.GetByUserID(e:GetInt("attacker"))
        local victim = entities.GetByUserID(e:GetInt("userid"))
        if attacker and victim and attacker:IsPlayer() and victim:IsPlayer() then
            local attackerIndex = attacker:GetIndex()
            local victimIndex = victim:GetIndex()
            if attackerIndex == localPlayerIndex then
                if not playerDamage[victimIndex] then
                    playerDamage[victimIndex] = { damageDealt = 0, hitsDealt = 0, damageTaken = 0, hitsTaken = 0 }
                end

                playerDamage[victimIndex].damageDealt = playerDamage[victimIndex].damageDealt + e:GetInt("dmg_health")
                playerDamage[victimIndex].hitsDealt = playerDamage[victimIndex].hitsDealt + 1
            end
            if victimIndex == localPlayerIndex then
                if not playerDamage[attackerIndex] then
                    playerDamage[attackerIndex] = { damageDealt = 0, hitsDealt = 0, damageTaken = 0, hitsTaken = 0 }
                end

                playerDamage[attackerIndex].damageTaken = playerDamage[attackerIndex].damageTaken + e:GetInt("dmg_health")
                playerDamage[attackerIndex].hitsTaken = playerDamage[attackerIndex].hitsTaken + 1
            end
        end
    end
    if eventName == "round_end" then
        local localPlayer = entities.GetLocalPlayer()
        for index, damageInfo in pairs(playerDamage) do
            local player = entities.GetByIndex(index)
            if player and player:IsPlayer() then
                local playerName = player:GetName()
                local playerHealth = player:GetHealth() or 0

                local damageDealt = damageInfo.damageDealt or 0
                local hitsDealt = damageInfo.hitsDealt or 0
                local damageTaken = damageInfo.damageTaken or 0
                local hitsTaken = damageInfo.hitsTaken or 0

                if player:GetTeamNumber() ~= localPlayer:GetTeamNumber() then
                    local message = string.format("\04To: [%d dmg / %d hits] - From: [%d dmg / %d hits] - %s (%d hp)", damageDealt, hitsDealt, damageTaken, hitsTaken, playerName, playerHealth)
                    ChatPrint(message)
                end
            end
        end
        playerDamage = {}
    end
end)
