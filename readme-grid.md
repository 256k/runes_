# runes grid

a grid interface for runes script or independent implementation

(maybe make it standalone on rpi through rnbo or pd or on daisy? tbd)

ideas and braindump:

runes step values:
------------------

1- trig -- next step index
2- note -- note
3- octv -- octave
4- clkd -- clock division
5- prob -- probability
6- dire -- direction (might change)

the layout
----------

2 views: 
1- overview
2- step view

overview:
---------
```
hsliders:   0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
[ ][ ][ ][ ][ ][ ][ ][ trig ][ ][ ][ ][ ][ ][ ][ ][ ]
[ ][ ][ ][ ][ ][ ][ ][ note ][ ][ ][ ][ ][ ][ ][ ][ ] 
[ ][ ][ ][ ][ ][ ][ ][ octv ][ ][ ][ ][ ][ ][ ][ ][ ] 
[ ][ ][ ][ ][ ][ ][ ][ clkd ][ ][ ][ ][ ][ ][ ][ ][ ] 
[ ][ ][ ][ ][ ][ ][ ][ prob ][ ][ ][ ][ ][ ][ ][ ][ ]
[ ][ ][ ][ ][ ][ ][ ][ dire ][ ][ ][ ][ ][ ][ ][ ][ ]
[ ][ ][ ][ ][ ][ ][ ][ XXXX ][ ][ ][ ][ ][ ][ ][ ][ ]
[ ][ ][ ][ ][ ][ ][ ][step sel ][ ][ ][ ][ ][ ][ ][ ]
```




- the top 6 rows will represent the 16 steps of each step property.
- each row will represent the corresponding step value from the list of step values at the top.
- each column of those rows will represent a step in the 16 steps of the sequencer. similar to how it is represented on the screen of norns.
- each button in that column will have a brightness value equivalent to the corresponding step value (0 to 15)
- the 7th row can remain empty or perhaps be used for a 7th property. but for now it will be empty
- the 8th row is a step selector and playhead indicator. pressing and holding a step will open the corresponding step view

step view
---------

```
hsliders:   0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
 trig:     [ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][x][ ][ ][ ][ ]
 note:     [ ][ ][ ][x][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ] 
 octv:     [ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][x][ ][ ] 
 clkd:     [ ][ ][ ][ ][x][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ] 
 prob:     [ ][ ][ ][ ][ ][ ][x][ ][ ][ ][ ][ ][ ][ ][ ][ ]
 dire:     [ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][x][ ][ ][ ][ ]
 XXXX      [ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]
step sel:  [ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]
```

- the top 6 row become horizontal sliders representing the value of the corresponsding step value slot with a value from 0 to 15
- pressing anywhere in a row will change the value of that selected step's slot value (trig, note, octv...etc) to the 0 to 15 value selected.
- the 8th row remains the same. 

[OPTIONAL]: the brightness level of each step can be representing the probability of that step.


