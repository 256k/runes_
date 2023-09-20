--.......................R U N E S.......................
--.................................................................
--
-- A step sequencer inspired by
-- Orca & nanoloop
-- 
-- by 256k
--.................................................................

-- rxn3&

local Step = {}

function Step:new(stepnum)

  local s = setmetatable({}, {
      __index = Step
  })
  
  s.trig = 0
  s.note = 0
  s.octv = 0
  s.cdiv = 0
  s.prob = 0
  s.dire = 0

  -- extra props
  s._stepnum = stepnum

  return s

end

function Step:draw()
  print("draw the step column at the self.stepnum position")
end


-- =========================================

local Track = {}

function Track:new()
  local t = setmetatable({}, {
      __index = Track
  })
  
  for i=1,16 do
    t.step[i] = Step:new(i)
  end
end


-- =========================================


local Sequencer = {}

function Sequencer:new()
  
  local sq = setmetatable({}, {
      __index = Sequencer
  })

  sq.track[1] = Track:new()

end


print("sequencer")
tab.print(Sequencer:new())

print("track 1")
tab.print(Sequencer[1])

print("step 3")
tab.print(sequencer[1][3])





















-- ===================================================


screenmap = {
-- {'t','n','o','m','d','j','p','c'},
{'.','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
{'0','0','0','0','0','0','0','0'},
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

stepval = {'0','1','2','3','4','x'}

-- define global variables:
cursorX = 1;
cursorY = 1;
 mod1 = 0;
mod2 = 0;
charSelector = 0;

tab.print(Step:new(5));

function init()
clock.run(function()  -- redraw the screen and grid at 15fps
    while true do
      clock.sleep(1/15)
      redraw()
    end
end)


end


local testvar = 0xf
local hexvar = string.format("%x", testvar)
print(testvar) 
print(hexvar)

function redraw()
  screen.clear()
  for yi = 1, 16 do
    
      for xi = 1, 8 do
        screen.level(1)
        screen.move(yi*7 + 4,xi*7 + 2)
        screen.text_center(hexvar)
        if xi == cursorX and yi == cursorY then screen.move(yi*7 + 4,xi*7 + 2) screen.level(15) screen.text_center(screenmap[yi][xi]) end
        screen.update()
      end
    end
end

function enc(n,d) 
  -- vertical
  if n == 2 then 
    if mod1 == 0 then 
      cursorX = util.clamp(cursorX -d , 1,8)
      
      else 
        charSelector = util.clamp(charSelector+d, 1,6)
        screenmap[cursorY][cursorX] = stepval[charSelector]
        end
    end
  
  -- horizontal
  if n == 3 then cursorY = util.clamp(cursorY + d , 1,16)  end
  
end


function key(n,z)
  if n==2 and z== 1 then
    mod1 = 1
    charSelector = 0
    else
      mod1 = 0
  end
    
end
