local versionURL = "https://raw.githubusercontent.com/ArtzHarvest/AimwareLuas/main/Updater/versions.txt"

local localVersion = "1.1"

local function downloadVersion()
    http.Get(versionURL, function(content)
        checkVersion(content)
    end)
end

local function checkVersion(remoteVersion)
    if remoteVersion > localVersion then
        local scriptURL = "https://raw.githubusercontent.com/ArtzHarvest/AimwareLuas/main/Updater/GithubUpdater.lua"

        http.Get(scriptURL, function(scriptContent)
            updateScript(scriptContent)
        end)
    end
end

local function updateScript(newScript)
    file.Write("GithubUpdater.lua", newScript)
    LoadScript("GithubUpdater.lua")
end

downloadVersion()

--this is version 1.1
