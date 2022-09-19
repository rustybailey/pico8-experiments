pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
	counter = 1
	beat = 1
	music(0)
	
	for i=1, 10 do
		make_circle(rnd(128), rnd(128), rnd(5) + 5, rnd(1) + 1)
	end
end

circles = {}
function make_circle(x,y,r,r_delta)
 circle = {
 	x = x,
 	y = y,
 	r = r,
 	r_delta = r_delta,
 	update = function(self)
 		self.r += self.r_delta
 		if counter % 16 == 0 then
 			self.r_delta *= -1
 		end
 	end,
 	draw = function(self)
 		circfill(self.x, self.y, self.r, beat)
 	end
 }
 return add(circles, circle)
end

function _update60()
	counter += 1
	if counter % 32 == 0 then
		beat += 1
	end
	for circle in all(circles) do
		circle:update()
	end
end

function _draw()
	cls()
	for circle in all(circles) do
		circle:draw()
	end
	print("beat: " .. beat, 6, 6, 15)
end
__sfx__
011000100f0530060022655216000f0530060022655006000f05300600226550f0530f0530f053226550060000600006000060000600006000060000600006000060000600006000060000600006000060000600
011000000c155001051b155001050c155001051b155001050c1550010516155001050c15500105161550010511155001051d1550010511155001051d155001051115500105161550010511155001051615500100
011000001b5501b5501b5501f550225502455027550000001b5501b55018550185501655216552165521655216552185501b5501d55022550000001b550185501655013550000000f5520f5520f5520f5520f552
__music__
03 00010244

