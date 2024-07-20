--.......................R U N E S.......................
--.................................................................
--
-- A step sequencer inspired by
-- Orca & nanoloop
--
-- by 256k
--.................................................................
--
--
--
--
--
--                      hello
--
--
--
--
--
--
--
--
--.................................................................


engine.name = 'PolyPerc'
MU = require "musicutil"
local nb = require "nb/lib/nb"


note_array = MU.generate_scale_of_length (1, "major", 16) 
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
print("init  rerun?")
  s.props.trig = 0 -- step number to jump to
  s.props.note = 0 -- note to play 
  s.props.octv = 4 -- octave of note
  s.props.clkd = 4 -- clock division
  s.props.prob = 15 -- step probability of triggering
  s.props.dire = 0 -- direction of sequence // unimplemented

  -- extra props
  s._idx = stepnum
  s._props_qty = 6

  return s
end

function Step:draw()
  -- print(self.props.trign)
  screen.move(0 + self._idx * 8, 10)
  for k, v in pairs(self.props) do
    screen.text(hex(v))
    screen.move_rel(-5, 8)
  end
end

function Step:play()
-- play a note based on note, oct and prob
-- print("play triggered", self.props.prob)

  if self.props.note > 0 and self.props.octv > 0 then
    local note = note_array[self.props.note]
    local octv = self.props.octv * 12
    local total_note = note + octv
    print("octv", octv)
    print("note", total_note)
    -- print("clock div: ", self.props.clkd)
    
    -- local player = params:lookup_param("voice_id"):get_player()
    -- player:play_note(total_note, 0.8, 0.2)

    local notefreq = MU.note_num_to_freq(total_note)
        -- local notefreq = MU.note_num_to_freq(util.clamp(total_note, 1, 100))

    print("notefreq", notefreq)
    engine.cutoff(3900)
    engine.hz(notefreq)
    engine.release(0.3)
    print("i played", self._idx)
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
  t.clock = 0
  for i = 1, 16 do -- track length
    t.step[i] = Step:new(i)
    -- tab.print(t.step[i])
  end
  return t
end

function Track:draw()
  for yi = 1, 16 do
    if yi == self.step_idx  then screen.level(15) else screen.level(1) end
    for xi = 1, 6 do
      if (xi > 0 and yi > 0) then
      local screen_char = hex(self.step[yi].props[proplist[xi]])
      screen.move(yi * 7 + 4, xi * 7 + 8)
      screen.text_center(screen_char)
      if xi == cursorX and yi == cursorY and self.step_idx ~= yi then -- this is for cursor
        screen.level(15)
        screen.move(yi * 7 + 4, xi * 7 + 8)
        screen.text_center(screen_char)
        screen.level(1)
      end
      end
    end
  end
end


function Track:step()
  -- increment step_idx based on step's clkd, dire
  -- step:play
end

function Track:step_inc()
  print("step_inc")
  local step_prob = ((100 / 15) * self.step[self.step_idx].props.prob ) 
  local chance = math.random(1,100)
  
  local hopp_step = self.step[self.step_idx].props.trig
  
  if (step_prob)  > chance then
    -- print("step works")
    -- print("step prob: ", step_prob)
    -- print("chance: ", chance)
    
    -- print("step index after set", self.step_idx)
    print("step index: ", self.step_idx)
    self.step[self.step_idx]:play()
    if hopp_step > 0 then self.step_idx = hopp_step end
  end
  
  if self.step_idx == 16 then self.step_idx = 1 else self.step_idx = self.step_idx + 1 end
end

function Track:run()
self.clock = clock.run(function()
  local clockdiv = self.step[self.step_idx].props.clkd
  
    while true do
      if clockdiv ~= 0 then clockdiv = self.step[self.step_idx].props.clkd end
      -- print("clock div inside clock: ", clockdiv)
      clock.sync((1/16) * clockdiv)
      redraw()
      self:step_inc()
      
      
    end
  end)
end

function Track:randomize()
  for i = 1, #self.step do
    for k,v in pairs(self.step[i].props) do
        -- if math.random(1,10) == 3 then
          self.step[i].props[k] = math.random(0,15)
        -- end
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

function Track:pause()
clock.cancel(self.clock)  
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
  nb:init()
  nb:add_param("voice_id", "voice")
  nb:add_player_params()
  redraw()
end


-- init new sequencer with 5 tracks
local MASTER = Sequencer:new(1)
MASTER.track[1].step[1].props.note = 5
MASTER:run()

function hex(val)
  if val == 0 then return "." end
  return string.format("%x", val)
end

-- =============== SCREEN DRAWING: ======================

function redraw()
  screen.clear()
  draw_track_id()
  MASTER.track[trackSelector]:draw()
  screen.update()
end

-- =====================================


function enc(n, d)
  redraw()
  -- vertical
  if n == 2 then
    if mod1 == 0 then
      cursorX = util.clamp(cursorX + (d / 2), 1, 6)
    else
      charSelector = util.clamp(charSelector + d, 0, 15)
      MASTER.track[trackSelector].step[cursorY].props[proplist[cursorX]] = charSelector
      print("proplist" , proplist[cursorX])
      tab.print(MASTER.track[trackSelector].step[cursorY].props)
    end
  end

  -- horizontal
  if n == 3 then cursorY = util.clamp(cursorY + d, 1, 16) 
    redraw()
    end
  
  
  if n == 1 then 
    trackSelector = (util.clamp(trackSelector + d, 1, #MASTER.track)) 
    
    redraw()
  end



end

function key(n, z)
  if n == 1 and z ==1 then
  --   print("=========MASTER.track[trackSelector]========")
  -- tab.print(MASTER.track[trackSelector])
  -- print("----------------------")
    if mod1 == 1 then MASTER.track[trackSelector]:clear() else MASTER.track[trackSelector]:randomize()  end
  end
  
  if n == 2 and z == 1 then
    mod1 = 1
    charSelector = 0
  else
    mod1 = 0
  end
  
  if n == 3 and z == 1 then
  MASTER.track[trackSelector]:pause()
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
screen.level(1)
screen.text_center(MASTER.track[trackSelector].trackid)
end



