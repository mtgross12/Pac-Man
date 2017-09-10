# Pac-Man
Date: April 30th, 2017
Authors:
Kyle Hand
Matthew Gross
Class: ECE 385- Digital Systems Laboratory Final Project

Summary of this project (What is is and How it was carried out)

We started off with a large majority of our time spent planning how to code this entire project up.
We knew we wanted to put a little spin on the original Pac-Man game, but also wanted to pay it
homeage as it was a classic game that many enjoy.
Initial Goals:
- Make a controllable Pac-Man
- Make ghosts that move randomly
- Make ghosts that move semi-randomly but generally search for Pac-Man (like the real game)
- Make different maps to play on
- Make different game modes
- Allow for simultaneous 2 player Pac-Man
- Keep track of and display points

We started off wanting to use sprites overlayed onto a map, but the need for having sprite 
interaction with the map peices essentially would have doubled our work for us. So we made the switch
to sprites for every peice on the board: Pac-Man, Ghosts, points, and powerups as well as every wall peice and corner.

Though this design change was rather slight, it later allowed for us to build on what we had in a more modular sense.
The point being that though we struggled to meet our timeline as is, we made it easier to add onto later on.

Design Implementation:
We divided our project into 3 parts:
Sprites and their Controls
Map
Visuals

We began with simple display of the map through a VGA controller we had made in an earlier lab section. This specific
controller took a block of memory and displayed its coorelated values to the 600x800 screen we all know and love.
The map was loaded into this memory block and changes are made to it with the controls section.
The controls section changes every tick of the game clock (in this module, once every second)
and takes the keypress from the WASD keys or the arrow keys to change the direction of pacman,
and then move the ghosts
and then check to see if Pac-Man is dead or not or if he scored points.
The modularity of this build makes it easy to add in the powerPuck which is what turns all the ghosts blue
and also edible for pacman. 
Once all these changes are squared away, the changes are translated from a 0-7 numbering system to the 0-3 color system by checking the sprites. For example, the empty space sprite was made up of all black pixels so we translate the 0 number sprite (empty space) into all 0's (all black) for 25x25 pixels and then load them into the RAM to be read by the VGA controller.

And this process repeats until the game is powered off or the reset is manually hit on the programmable processor.

