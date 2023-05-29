        local local_version = "1.1"
        ---@diagnostic disable-next-line: undefined-global
        local local_script_name = GetScriptName()
        local github_version_url = "https://raw.githubusercontent.com/ArtzHarvest/AimwareLuas/main/Updater/versions.txt"
        local github_version = http.Get(github_version_url)
        local github_source_url = "https://raw.githubusercontent.com/ArtzHarvest/AimwareLuas/main/Updater/GithubUpdater.lua"

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

        --version 1.1
