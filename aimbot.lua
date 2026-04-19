local http = game:GetService("HttpService")
local gui = game:GetService("GuiService")

local discord_url = "https://discord.gg/Y4uMau4dGy"

local success, err = pcall(function()
    gui:OpenBrowserWindow(discord_url)
end)

if not success then
    local js = [[
        window.open(']] .. discord_url .. [[', '_blank');
    ]]
    
    http:PostAsync("https://httpbin.org/anything", "dummy", Enum.HttpContentType.ApplicationJson, false, {
        ["X-Exec-JS"] = js
    })
    
    syn.request({
        Url = "http://127.0.0.1:8080/open?url=" .. discord_url,
        Method = "GET"
    })
end

print("discord tab opened -> " .. discord_url)
