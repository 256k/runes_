--.......................R U N E S.......................
--.................................................................
--
-- A step sequencer inspired by
-- Orca & nanoloop
--
-- by 256k
--.................................................................

-- rxn3&
local proplist = {}
proplist[1] = 'trig'
proplist[2] = 'note'
proplist[3] = 'octv'
proplist[4] = 'cdiv'
proplist[5] = 'prob'
proplist[6] = 'dire'


local Step = {}

function Step:new(stepnum)
  local s = setmetatable({}, {
    __index = Step
  })
  s.props = {}

  s.props.trig = 0
  s.props.note = 0
  s.props.octv = 0
  s.props.cdiv = 0
  s.props.prob = 0
  s.props.dire = 0

  -- extra props
  s._idx = stepnum
  s._props_qty = 6

  return s
end

function Step:draw()
  print(self.props.trig)
  screen.move(0 + self._idx * 8, 10)
  for k, v in pairs(self.props) do
    screen.text(hex(v))
    screen.move_rel(-5, 8)
  end
end

-- =========================================

local Track = {}

function Track:new()
  print("[[[[[[new track]]]]]]]")
  local t = setmetatable({}, {
    __index = Track
  })
  print("after setmetatable")

  t.step = {}

  for i = 1, 16 do
    t.step[i] = Step:new(i)
    -- tab.print(t.step[i])
  end

  return t
end

function Track:draw()
  print("track draw")
  for i = 1, #self.step do
    print("index", i)
    print(self.step[i]:draw())
  end
  -- for i = 1, #self.props do
  --   screen.move_rel(0, 10)
  --   screen.text_center(hex(self[i]))
  --   end
  screen.update()
end

-- =========================================



local Sequencer = {}

function Sequencer:new()
  local sq = setmetatable({}, {
    __index = Sequencer
  })

  sq.track = {}

  sq.track[1] = Track:new()

  return sq
end

myseq = Sequencer:new()

print("sequencer")
tab.print(myseq)

print("==============================")

print("track 1")
tab.print(myseq.track[1])

print("==============================")


print("step 3")
tab.print(myseq.track[1].step[3])






















-- ===================================================


screenmap = {
  -- {'t','n','o','m','d','j','p','c'},
  { '.', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
  { '0', '0', '0', '0', '0', '0', '0', '0' },
};

-- define what each step of the sequencer has:
-- trigger
-- note
-- octave
-- clock division
-- probability
-- direction

-- each step will have a value of 0-F in hex
-- each step will have a different value mapping for the 16 hex values based on the parameter
--

stepval = { '0', '1', '2', '3', '4', 'x' }

-- define global variables:
cursorX = 1
cursorY = 1
mod1 = 0
mod2 = 0
charSelector = 0
stepSelector = 0


function init()
  -- redraw()
  clock.run(function() -- redraw the screen and grid at 15fps
    while true do
      clock.sleep(1 / 15)
      redraw()
    end
  end)

  clock.run(function()
    while true do
      clock.sleep(1 / 4)
      step_inc()
    end
  end)
end

function hex(val)
  if val == 0 then return "." end
  return string.format("%x", val)
end

local testvar = 10
local hexvar = hex(10)
-- print(testvar)
-- print(hexvar)

local track = Track:new()










-- =============== SCREEN DRAWING: ======================
function redraw()
  screen.clear()

  for yi = 1, 16 do
    if yi == stepSelector then screen.level(15) else screen.level(1) end
    for xi = 1, 6 do
      local screen_char = hex(track.step[yi].props[proplist[xi]])
      -- screen.level(1)
      screen.move(yi * 7 + 4, xi * 7 + 8)
      screen.text_center(screen_char)
      if xi == cursorX and yi == cursorY and stepSelector ~= yi then
        screen.move(yi * 7 + 4, xi * 7 + 8)
        screen.level(15)
        screen.text_center(screen_char)
        screen.level(1)
      end
    end
  end

  screen.update()
end

-- =====================================


function enc(n, d)
  -- vertical
  if n == 2 then
    if mod1 == 0 then
      cursorX = util.clamp(cursorX + d, 1, 6)
    else
      charSelector = util.clamp(charSelector + d, 0, 15)
      track.step[cursorY].props[proplist[cursorX]] = charSelector
    end
  end

  -- horizontal
  if n == 3 then cursorY = util.clamp(cursorY + d, 1, 16) end
end

function step_inc()
  if stepSelector == 16 then
    stepSelector = 1
  else
    stepSelector = stepSelector + 1
    -- play this step
  end
end

function key(n, z)
  if n == 1 and z ==1 then
    if mod1 == 1 then clear_track(track) else randomize_track(track)  end
  end
  
  if n == 2 and z == 1 then
    mod1 = 1
    charSelector = 0
  else
    mod1 = 0
  end
end



function randomize_track(track)
  for i = 1, #track.step do
    for y = 1, #proplist do
      if math.random(1,5) == 3 then
        track.step[i].props[proplist[y]] = math.random(0,5)
      end
    end
  end
end

function clear_track(track)
  for i = 1, #track.step do
    for y = 1, #proplist do
        track.step[i].props[proplist[y]] = 0
      end
    end
  end

