--.......................R U N E S.......................
--.................................................................
--
-- A step sequencer inspired by
-- Orca & nanoloop
-- 
-- by 256k
--.................................................................
screenmap = {
-- {'t','n','o','m','d','j','p','c'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
{'.','.','.','.','.','.','.','.'},
};

stepval = {'.','1','2','3','4','x'}

-- define global variables:
cursorX = 1;
cursorY = 1;
mod1 = 0;
mod2 = 0;
charSelector = 0;

function init()
clock.run(function()  -- redraw the screen and grid at 15fps
    while true do
      clock.sleep(1/15)
      redraw()
    end
  end)
end

function redraw()
  screen.clear()
  for yi = 1, 16 do
    
      for xi = 1, 8 do
        screen.level(1)
        screen.move(yi*7 + 4,xi*7 + 2)
        screen.text_center(screenmap[yi][xi])
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

