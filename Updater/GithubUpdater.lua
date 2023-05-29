-- URL zum Textdokument mit der Versionsnummer auf GitHub
local versionURL = "https://raw.githubusercontent.com/dein_github_repository/versions.txt"

local localVersion = "1.0"

-- Lade die neueste Versionsnummer herunter
local function downloadVersion()
    http.Get(versionURL, function(content)
        checkVersion(content)
    end)
end

-- Vergleiche die Versionen und führe bei Bedarf ein Update durch
local function checkVersion(remoteVersion)
    if remoteVersion > localVersion then
        -- URL zum herunterladbaren Script auf GitHub
        local scriptURL = "https://raw.githubusercontent.com/dein_github_repository/script.lua"

        -- Lade das aktualisierte Script herunter
        http.Get(scriptURL, function(scriptContent)
            updateScript(scriptContent)
        end)
    end
end

-- Aktualisiere das Script und lade es neu
local function updateScript(newScript)
    file.Write("Pfad/zum/lokalen/script.lua", newScript)
    LoadScript("Pfad/zum/lokalen/script.lua")
end

-- Überprüfe die Version beim Start
downloadVersion()
