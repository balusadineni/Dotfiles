ctrlCmdShortcuts = {
	{ "A", "Alacritty" },
	{ "V", "Visual Studio Code" },
	{ "F", "Firefox" },
	{ "C", "Google Chrome" },
	{ "S", "Slack" },
	{ "N", "Neovide" },
}

cmdShiftShortcuts = {
	{ "C", "Calendar" },
	{ "M", "Mail" },
	{ "M", "Music" },
	{ "F", "Finder" },
	{ "S", "Safari" },
}

for i, shortcut in ipairs(ctrlCmdShortcuts) do
	hs.hotkey.bind({ "ctrl", "cmd" }, shortcut[1], function()
		hs.application.launchOrFocus(shortcut[2])
	end)
end

for i, shortcut in ipairs(cmdShiftShortcuts) do
	hs.hotkey.bind({ "cmd", "shift" }, shortcut[1], function()
		hs.application.launchOrFocus(shortcut[2])
	end)
end

function moveToNextScreen()
	local app = hs.window.focusedWindow()
	app:moveToScreen(app:screen():next())
	app:setFullScreen(true)
end

function maximizeScreen()
	local app = hs.window.focusedWindow()
	app:maximize(true)
end

function toggleFullScreen()
	local app = hs.window.focusedWindow()
	app:toggleFullScreen(true)
end

hs.hotkey.bind({ "cmd" }, "n", moveToNextScreen)
hs.hotkey.bind({ "cmd" }, "l", maximizeScreen)
hs.hotkey.bind({ "cmd" }, "m", toggleFullScreen)
