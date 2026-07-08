-- Philippe's Hamerspoon configuration

local log = hs.logger.new("wm", "debug")

-- Helper to get a usable window
local function getTargetWindow()
    return hs.window.focusedWindow() or hs.window.frontmostWindow()
end


-- Move focused window to the left half of the screen
hs.hotkey.bind({"cmd", "alt"}, "Left", function()
    log.df("Move window to left half of the screen")
    local win = hs.window.focusedWindow()
    -- log.df("window win: %s", tostring(win))
    if not win then return end

    local screen = win:screen()

    local screenFrame = screen:frame() -- excludes menu bar and dock

    local newFrame = {
        x = screenFrame.x,
        y = screenFrame.y,
        w = screenFrame.w / 2,
        h = screenFrame.h
    }

    win:setFrame(newFrame)
end)

-- Move focused window to the left 1/3 of the screen
hs.hotkey.bind({"shift", "cmd", "alt"}, "Left", function()
    log.df("Move window to left 1/3 of the screen")
    local win = hs.window.focusedWindow()
    -- log.df("window win: %s", tostring(win))
    if not win then return end

    local screen = win:screen()

    local screenFrame = screen:frame() -- excludes menu bar and dock

    local newFrame = {
        x = screenFrame.x,
        y = screenFrame.y,
        w = screenFrame.w / 3,
        h = screenFrame.h
    }

    win:setFrame(newFrame)
end)

-- Move focused window to the right 1/3 of the screen
hs.hotkey.bind({"shift", "cmd", "alt"}, "Right", function()
    log.df("Move window to right 1/3 of the screen")
    local win = hs.window.focusedWindow()
    -- log.df("window win: %s", tostring(win))
    if not win then return end

    local screen = win:screen()

    local screenFrame = screen:frame() -- excludes menu bar and dock

    local third = math.floor(screenFrame.w / 3)
    local newFrame = {
        x = screenFrame.x + (2 * third),
        y = screenFrame.y,
        w = third,
        h = screenFrame.h
    }

    win:setFrame(newFrame)
end)

-- Move focused window to the right half of the screen
hs.hotkey.bind({"cmd", "alt"}, "Right", function()
    log.df("Move window to right half of the screen")
    local win = hs.window.focusedWindow()
    -- log.df("window win: %s", tostring(win))
    if not win then return end

    local screen = win:screen()

    local screenFrame = screen:frame() -- excludes menu bar and dock

    local newFrame = {
        x = screenFrame.x + (screenFrame.w / 2),
        y = screenFrame.y,
        w = screenFrame.w / 2,
        h = screenFrame.h
    }

    win:setFrame(newFrame)
end)


-- Deterministic screen ordering: left-to-right, then top-to-bottom
local function orderedScreens()
  local screens = hs.screen.allScreens()
  table.sort(screens, function(a, b)
    local fa, fb = a:frame(), b:frame()
    if fa.x == fb.x then
      return fa.y < fb.y
    end
    return fa.x < fb.x
  end)
  return screens
end

-- Move window to screen #n, preserving its relative position/size
local function moveWindowToScreen(n)
  log.df("Move window to another screen")
  local win = getTargetWindow()
  if not win then return end

  local screens = orderedScreens()
  local target = screens[n]
  if not target then
     local msg = "Screen " .. tostring(n) .. " not available"
     log.df(msg)
     hs.alert.show(msg)
    return
  end

  local currentScreen = win:screen()
  local wf = win:frame()

  local from = currentScreen:frame()
  local to = target:frame()

  -- Compute the window's position/size as fractions of the current screen
  local rx = (wf.x - from.x) / from.w
  local ry = (wf.y - from.y) / from.h
  local rw = wf.w / from.w
  local rh = wf.h / from.h

  -- Apply those fractions to the target screen
  local newFrame = {
    x = to.x + (rx * to.w),
    y = to.y + (ry * to.h),
    w = rw * to.w,
    h = rh * to.h
  }

  win:setFrame(newFrame)
end

-- Hotkeys: move to screen 1/2/3
hs.hotkey.bind({"cmd", "alt"}, "1", function() moveWindowToScreen(1) end)
hs.hotkey.bind({"cmd", "alt"}, "2", function() moveWindowToScreen(2) end)
hs.hotkey.bind({"cmd", "alt"}, "3", function() moveWindowToScreen(3) end)


-- Make focused window take full vertical space (keep x/width)
hs.hotkey.bind({"cmd", "alt"}, "Up", function()
  local win = getTargetWindow()
  if not win then
    print("No window found")
    return
  end

  local sf = win:screen():frame()
  local wf = win:frame()

  wf.y = sf.y
  wf.h = sf.h

  win:setFrame(wf)
end)


-- Center window horizontally at half screen width (full height)
hs.hotkey.bind({"cmd", "alt"}, "Down", function()
  local win = getTargetWindow()
  if not win then
    print("No window found")
    return
  end

  local sf = win:screen():frame()

  local newFrame = {
    x = sf.x + (sf.w / 4),  -- (screenWidth - halfWidth) / 2 = w/4
    y = sf.y,
    w = sf.w / 2,
    h = sf.h
  }

  win:setFrame(newFrame)
end)


hs.hotkey.bind({"cmd", "alt", "ctrl"}, 'D', function ()
      hs.application.launchOrFocus("Dictionary")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, 'C', function ()
      hs.application.launchOrFocus("Calendar")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, 'E', function ()
      hs.application.launchOrFocus("/Applications/Emacs.app")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, 'T', function ()
      hs.application.launchOrFocus("/Applications/iTerm.app")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, 'S', function ()
      hs.application.launchOrFocus("/Applications/Safari.app")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, 'G', function ()
      hs.application.launchOrFocus("/Applications/Google Chrome.app")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, 'V', function ()
      hs.application.launchOrFocus("/Applications/Visual Studio Code.app")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, 'K', function ()
      hs.application.launchOrFocus("/Applications/Slack.app")
end)

-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, 'I', function ()
--       hs.application.launchOrFocus("/Applications/'IntelliJ IDEA CE.app'")
-- end)

function open(name)
    return function()
        hs.application.launchOrFocus(name)
        if name == 'Finder' then
            hs.appfinder.appFromName(name):activate()
        end
    end
end
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "I", open("IntelliJ IDEA CE"))


--   ⌃⌥⌘W  -> Minimize all visible windows
--   ⇧⌃⌥⌘W -> Restore the last batch

local lastMinimized = {}

local function minimizeAllVisible()
  lastMinimized = {}
  for _, w in ipairs(hs.window.visibleWindows()) do
    if w:isStandard() and not w:isMinimized() then
      local app = w:application()
      if app and app:name() ~= "Hammerspoon" then
        table.insert(lastMinimized, w)
        w:minimize()
      end
    end
  end
end

local function restoreLastBatch()
  for _, w in ipairs(lastMinimized) do
    if w and w:isMinimized() then
      w:unminimize()
    end
  end
  lastMinimized = {}
end


hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", minimizeAllVisible)
hs.hotkey.bind({"shift", "cmd", "alt", "ctrl"}, "W", restoreLastBatch)


-- hs.loadSpoon("ToggleScreenRotation")
-- spoon.ToggleScreenRotation:bindHotkeys( { ["BFP100-27"] = {{"cmd", "alt", "ctrl"}, "r" } } )

--[[ debug

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

hs.hotkey.bind({ "cmd", "alt", "ctrl"}, "e", function ()
      -- hs.alert.show(hs.screen.allScreens()[0]:name())
      hs.alert.show(dump(hs.screen.allScreens()))
end)

]]
