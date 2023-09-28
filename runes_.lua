--.......................R U N E S.......................
--.................................................................
--
-- A step sequencer inspired by
-- Orca & nanoloop
--
-- by 256k
--.................................................................

engine.name = 'PolyPerc'
MU = require "musicutil"

-- rxn3&
local proplist = {}
proplist[1] = 'trig'
proplist[2] = 'note'
proplist[3] = 'octv'
proplist[4] = 'clkd'
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
  s.props.clkd = 0
  s.props.prob = 0
  s.props.dire = 0

  -- extra props
  s._idx = stepnum
  s._props_qty = 6

  return s
end

function Step:draw()
  -- print(self.props.trig)
  screen.move(0 + self._idx * 8, 10)
  for k, v in pairs(self.props) do
    screen.text(hex(v))
    screen.move_rel(-5, 8)
  end
end

function Step:play()
-- play a note based on note, oct and prob
-- print("play triggered")

if self.props.note > 0 and self.props.octv > 0 then
local notefreq = MU.note_num_to_freq(self.props.note + (self.props.octv * 12))
engine.cutoff(3900)
engine.hz(notefreq)
end
end



-- =========================================

local Track = {}

function Track:new(trackid)
  local t = setmetatable({}, {
    __index = Track
  })

  t.step = {}
  t.step_idx = 1
  t.trackid = trackid or 1
  for i = 1, 16 do
    t.step[i] = Step:new(i)
    -- tab.print(t.step[i])
  end
  return t
end

function Track:draw()
  for yi = 1, 16 do
    if yi == self.step_idx then screen.level(15) else screen.level(1) end
    for xi = 1, 6 do
      local screen_char = hex(self.step[yi].props[proplist[xi]])
      -- screen.level(1)
      screen.move(yi * 7 + 4, xi * 7 + 8)
      screen.text_center(screen_char)
      if xi == cursorX and yi == cursorY and self.step_idx ~= yi then
        
        screen.level(15)
        screen.fill()
        screen.rect(yi * 7 + 1 , xi * 7 +2, 7, 7)
        screen.move(yi * 7 + 4, xi * 7 + 8)
        screen.blend_mode(1)
        screen.text_center(screen_char)
        
        screen.level(1)
      end
    end
  end
end


function Track:step()
  -- increment step_idx based on step's clkd, dire
  -- step:play
end

function Track:step_inc()
  -- print("step inc", self.trackid) 
  if self.step_idx == 16 then self.step_idx = 1 else self.step_idx = self.step_idx + 1 end
    -- print("step_idx", self.step_idx)
    self.step[self.step_idx]:play()
  -- tab.print(self.step[self.step_idx])
end

function Track:run()
clock.run(function()
    while true do
      clock.sync(1 / 4)
      -- self:trigger()
      -- redraw()
      -- print("track tick")
      self:step_inc()
      redraw()
    end
  end)
end

function Track:randomize()
  for i = 1, #self.step do
    for k,v in pairs(self.step[i].props) do
        if math.random(1,10) == 3 then
          self.step[i].props[k] = math.random(0,15)
        end
    end
  end
end

function Track:clear()
  for i = 1, #self.step do
    for k,v in pairs(self.step[i].props) do
        
          self.step[i].props[k] = 0
      
    end
  end
end


-- =========================================



local Sequencer = {}

function Sequencer:new(tracknum)
  local sq = setmetatable({}, {
    __index = Sequencer
  })

  sq.track = {}

  for i = 1, tracknum or 1 do
  sq.track[i] = Track:new(i)  
  end
  

  return sq
end

function Sequencer:run()
  for i = 1, #self.track do
     self.track[i]:run()
  end
end

-- myseq = Sequencer:new()

-- print("sequencer")
-- tab.print(myseq)

-- print("==============================")

-- print("track 1")
-- tab.print(myseq.track[1])

-- print("==============================")


-- print("step 3")
-- tab.print(myseq.track[1].step[3])






















-- ===================================================


-- screenmap = {
--   -- {'t','n','o','m','d','j','p','c'},
--   { '.', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
--   { '0', '0', '0', '0', '0', '0', '0', '0' },
-- };

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

-- stepval = { '0', '1', '2', '3', '4', 'x' }

-- define global variables:







cursorX = 1
cursorY = 1
mod1 = 0
mod2 = 0
charSelector = 0
stepSelector = 0
trackSelector = 1


function init()
  redraw()
  -- clock.run(function() -- redraw the screen and grid at 15fps
  --   while true do
  --     clock.sleep(1 / 15)
  --     redraw()
  --   end
  -- end)

--   clock.run(function()
--     while true do
--       clock.sleep(1 / 4)
--       step_inc()
--     end
--   end)
end


-- init new sequencer with 5 tracks
local MASTER = Sequencer:new(5)
MASTER:run()

function hex(val)
  if val == 0 then return "." end
  return string.format("%x", val)
end


-- local track = Track:new()
-- track:run()









-- =============== SCREEN DRAWING: ======================




function redraw()
  screen.clear()
  draw_track_id()
  MASTER.track[trackSelector]:draw()
  -- for yi = 1, 16 do
  --   if yi == track.step_idx then screen.level(15) else screen.level(1) end
  --   for xi = 1, 6 do
  --     local screen_char = hex(track.step[yi].props[proplist[xi]])
  --     -- screen.level(1)
  --     screen.move(yi * 7 + 4, xi * 7 + 8)
  --     screen.text_center(screen_char)
  --     if xi == cursorX and yi == cursorY and track.step_idx ~= yi then
  --       screen.move(yi * 7 + 4, xi * 7 + 8)
  --       screen.level(15)
  --       screen.text_center(screen_char)
  --       screen.level(1)
  --     end
  --   end
  -- end

  screen.update()
end

-- =====================================


function enc(n, d)
  redraw()
  -- vertical
  if n == 2 then
    if mod1 == 0 then
      cursorX = util.clamp(cursorX + d, 1, 6)
    else
      charSelector = util.clamp(charSelector + d, 0, 15)
      MASTER.track[trackSelector].step[cursorY].props[proplist[cursorX]] = charSelector
    end
  end

  -- horizontal
  if n == 3 then cursorY = util.clamp(cursorY + d, 1, 16) end
  
  
  if n == 1 then 
    trackSelector = (util.clamp(trackSelector + d, 1, #MASTER.track)) 
    
    redraw()
  end



end

-- function step_inc()
--   if track.step_idx == 16 then
--     track.step_idx = 1
--   else
--     track.step_idx = stepSelector + 1
--     -- play this step
--   end
-- end

function key(n, z)
  if n == 1 and z ==1 then
    print("=========MASTER.track[trackSelector]========")
  tab.print(MASTER.track[trackSelector])
  print("----------------------")
    if mod1 == 1 then MASTER.track[trackSelector]:clear() else MASTER.track[trackSelector]:randomize()  end
  end
  
  if n == 2 and z == 1 then
    mod1 = 1
    charSelector = 0
  else
    mod1 = 0
  end
end


-- i need to make as much as i can the functions be pure functions like these ones. 
-- they dont know anything about the master track. but we'll see later.
-- right now im just speedrunning through the core functionality

function randomize_track(track)
  print("=========track========")
  tab.print(tarck)
  print("----------------------")
  for i = 1, #track.step do
  for k,v in pairs(track.step.props) do
    
  
  --   for y = 1, #proplist do
  --     if math.random(1,15) == 3 then
  track[trackSelector].step[i].props[k] = math.random(0,15)
  --     end
  --   end
  end
  end
end

function clear_track(track)
  for i = 1, #track.step do
    for y = 1, #proplist do
  track[trackSelector].step[i].props[proplist[y]] = 0
      end
    end
end

function draw_track_id()
screen.move(4 , 10)
screen.text_center(MASTER.track[trackSelector].trackid)
end



