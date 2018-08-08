First, credit is due to:

Jos Stam
http://www.dgp.toronto.edu/people/stam/reality/Research/pdf/ns.pdf

Phillip Rideout
http://prideout.net/blog/?p=58

GPU Gems 1

Thomas Diewald
https://github.com/diwi/PixelFlow

Burton Radons
https://github.com/Burton-Radons/




Please clone this from
https://github.com/ancillarymagnet/touchfluids
... to get the updates I'll inevitably make
when I realize how broken this is.

If you just want to mess with some fluids,
open the parent viewer (shift-V) and left
click to 'paint' with pink ink and force.


To change the setup of this scene like the
resolution and dissipation settings, monkey
with the parent parameters. You'll probably need
to reset the feedback at that point.

If you want to introduce your own starting
conditions or 'static' elements (stuff and 
force), change the inputs to the nulls labeled 
yellow. Anything can go in there but pay at-
tention to pixel formats - you'll want to match
what's there, and it's a clue to what those
textures do in the computation.

For example - force is floating point in RG, where
the red channel is X force and the green is Y force.
As an eg., have a look at 'circl34', which is adding
a quantity of vertical force to the simulation. It has
0 in its red channel and 0.2 in its green channel,
which is the positive Y force that is creating the
convection you see.

'Stuff', or ink, is also floating-point, and can
have negative values, which means it can behave
either additively (like light), or subtractively,
like a mix of the behaviors of light and ink. It's
not CMYK but can withdraw value from the RGB color
channels.

As an eg, the 'circle1' op is adding the value 
'-0.7,-0.7,-0.7', thus pulling color out of the simulation.
Pure white that makes it into that triangle will come out grey.

The 'starting' nulls allow you to set the initial conditions
that will be present when you reset the simulation with
the 'Resetfb' par in the custom parameters. I've added a
banana in there as a sop to the banana fundamentalists among us.
Not that kind of sop.

I've also exposed some of the 'constant' parameters used in the
Navier-Stokes equations. Playing with them can break the simulation in
fun and fantastic ways, but I *think* they're 'right' as they are.

Please let me know if you find some bunk math or bad practices.
This was my first big GLSL project and I haven't touched it in more
than a year, so, you know, YMMV, no express warranty, etc.

ENJOY!

Noah
n@hardwork.party
@hardworkparty



Phillip Rideout
http://prideout.net/blog/?p=58

GPU Gems 1

Thomas Diewald
https://github.com/diwi/PixelFlow

Burton Radons
https://github.com/Burton-Radons/




Please clone this from
https://github.com/ancillarymagnet/touchfluids
... to get the updates I'll inevitably make
when I realize how broken this is.

If you just want to mess with some fluids,
open the parent viewer (shift-V) and left
click to 'paint' with pink ink and force.


To change the setup of this scene like the
resolution and dissipation settings, monkey
with the parent parameters. You'll probably need
to reset the feedback at that point.

If you want to introduce your own starting
conditions or 'static' elements (stuff and 
force), change the inputs to the nulls labeled 
yellow. Anything can go in there but pay at-
tention to pixel formats - you'll want to match
what's there, and it's a clue to what those
textures do in the computation.

For example - force is floating point in RG, where
the red channel is X force and the green is Y force.
As an eg., have a look at 'circl34', which is adding
a quantity of vertical force to the simulation. It has
0 in its red channel and 0.2 in its green channel,
which is the positive Y force that is creating the
convection you see.

'Stuff', or ink, is also floating-point, and can
have negative values, which means it can behave
either additively (like light), or subtractively,
like a mix of the behaviors of light and ink. It's
not CMYK but can withdraw value from the RGB color
channels.

As an eg, the 'circle1' op is adding the value 
'-0.7,-0.7,-0.7', thus pulling color out of the simulation.
Pure white that makes it into that triangle will come out grey.

The 'starting' nulls allow you to set the initial conditions
that will be present when you reset the simulation with
the 'Resetfb' par in the custom parameters. I've added a
banana in there as a sop to the banana fundamentalists among us.
Not that kind of sop.

I've also exposed some of the 'constant' parameters used in the
Navier-Stokes equations. Playing with them can break the simulation in
fun and fantastic ways, but I *think* they're 'right' as they are.

Please let me know if you find some bunk math or bad practices.
This was my first big GLSL project and I haven't touched it in more
than a year, so, you know, YMMV, no express warranty, etc.

ENJOY!

Noah
@hardworkparty

