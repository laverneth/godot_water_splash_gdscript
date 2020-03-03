# water_node
## What is is?
A 2d water node in pure gdscript for Godot 3.2. You can bring it easily to your project to simulate water like a small river or a pond. 

![alt tag](https://github.com/laverneth/godot_water_splash_gdscript/blob/master/water_node_parameters.png)

## Parameters:
- nb tiles: number of tiles in the x direction
- Width: width in pixel of each tile (the image in the repo is 32 width by 64 height)
- Height: height in pixel of each tile
- Damping: damping of the oscillations of the waves
- Tension: rigity of the water (high is stiff, low is "fluid")
- Spread: affect the size of the waves
 -Drag: how velocity of colliding body create wave depending on the x or y component.

Just add a texture to see the water, otherwise nothing is displayed. I have put a sample water texture for you. You can also modify the code to only display a polygon with a color and no texture.

Sometimes it's better to play a little bit with the parameters to understand how it works.
You can add particles, shaders, whatever you want to make the water even more realistic.

Feel free yo use in your awesome project, and do not hesitate to share, I'll retweet it them!

https://twitter.com/thomas_laverne

keep smiling and love for godot!
