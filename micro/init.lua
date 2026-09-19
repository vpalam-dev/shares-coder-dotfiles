-- Fuzzy open from inside micro, using the ff-pick / fs-pick helpers.
-- Alt-free on purpose: the Unpeel terminal sends Option as a character.
local micro = import("micro")
local shell = import("micro/shell")
local config = import("micro/config")

local function quote(path)
    return "'" .. path:gsub("'", "'\\''") .. "'"
end

-- Ctrl-p / `ff`: pick files by name (Tab selects several), one tab each.
function ffOpen(bp)
    local out, err = shell.RunInteractiveShell("ff-pick", false, true)
    if err ~= nil then return end
    for path in out:gmatch("[^\r\n]+") do
        bp:HandleCommand("tab " .. quote(path))
    end
end

-- F7 / `fs`: search file contents, open the match in a tab at its line.
function fsOpen(bp)
    local out, err = shell.RunInteractiveShell("fs-pick", false, true)
    if err ~= nil then return end
    local path, line = out:match("^([^\r\n]-):(%d+)")
    if path == nil then return end
    bp:HandleCommand("tab " .. quote(path))
    micro.CurPane():HandleCommand("goto " .. line)
end

function init()
    config.MakeCommand("ff", function(bp, args) ffOpen(bp) end, config.NoComplete)
    config.MakeCommand("fs", function(bp, args) fsOpen(bp) end, config.NoComplete)
end
