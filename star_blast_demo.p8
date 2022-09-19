pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
world = {
	max_x = 127,
	max_y = 127,
	counter = 1
}
stars = {}

function make_star(x,y)
	local colors = {1, 4, 6,6,6,7,7,7,7,7,7}
	local color = colors[flr(rnd(#colors)) + 1]
	local star = {
		x = x,
		y = y,
		color = color,
		update = function(self)
			self.y += .5
			if self.y > world.max_y + world.max_y then
				del(stars, self)
			end
		end,
		draw = function(self)
			pset(self.x,self.y, self.color)
			-- print(self.color, self.x, self.y)
		end
	}

	add(stars, star)
end

ship={
	x=64,
	y=120,
	w=8,
	h=8,
	dx=0,
	dy=0,
	ddx=0,
	ddy=0,
	max_acc = 2,
	update=function(self)
		self.ddx = 0
		self.ddy = 0
		if(btn(0)) then
			self.ddx=-.15
		end

		if(btn(1)) then
			self.ddx=.15
		end

		if(btn(2)) then
			self.ddy=-.15
		end

		if(btn(3)) then
			self.ddy=.15
		end

		if self.ddx == 0 then
			self.dx *= 0.95
		end
		
		if self.ddy == 0 then		
			self.dy *= 0.95
		end

		self.dx+=self.ddx
		self.dy+=self.ddy
		
		
		if self.dx > self.max_acc then
	    self.dx = self.max_acc
		elseif self.dx < -self.max_acc then
	    self.dx = -self.max_acc
		end

		if self.dy > self.max_acc then
	    self.dy = self.max_acc
		elseif self.dy < -self.max_acc then
	    self.dy = -self.max_acc
		end
		
		self.x+=self.dx
		self.y+=self.dy

		if (self.x < 0) then
			self.x = 0
		end

		if (self.x + self.w > world.max_x) then
			self.x = world.max_x - self.w
		end

		if (self.y < 0) then
			self.y = 0
		end

		if (self.y + self.h > world.max_y) then
			self.y = world.max_y - self.h
		end

  -- borrow button code and make this only happen every 24/30 frames
		if(btnp(4)) then
			make_blast(self.x,self.y)
		end

		-- borrow button code and make this only happen every 4/6/12 frames
		if(btnp(5)) then
			make_bullet(self.x,self.y)
		end
	end,
	draw=function(self)
		spr(4,self.x,self.y)
	end
}

blasts = {}
function make_blast(x,y)
	local blast = {
		x = x,
		y = y,
		dy = 1,
		sprite = 1,
		update = function(self)
			self.y -= self.dy
			if self.y < 0 then
				del(blasts, self)
			end

	  	if world.counter % 4 == 0 then
	  		self.sprite += 1
	  	end

	  	if self.sprite > 3 then
	  		self.sprite = 1
	  	end
		end,
	 	draw=function(self)
	 		spr(self.sprite, self.x, self.y)
	 	end
	}
	add(blasts, blast)
end

bullets = {}
function make_bullet(x,y)
	local bullet = {
		x = x,
		y = y,
		dy = 2,
		color = 12,
		update = function(self)
			self.y -= self.dy
			if self.y < 0 then
				del(bullets, self)
			end
		end,
 	draw=function(self)
 		line(self.x+4, self.y, self.x+4, self.y + 4, self.color)
 	end
	}
	add(bullets, bullet)
end

function _init()
	for i=1, 130, 1 do
		local x = flr(rnd(127))
		local y = flr(rnd(127))
		make_star(x,y)
	end
end

function _update60()
	world.counter += 1
	if world.counter > 60 then
		world.counter = 1
	end

	if world.counter % 4 == 0 then
		make_star(flr(rnd(127)), flr(rnd(20)) + -20)
	end


	for key, star in pairs(stars) do
		star:update()
	end

	for key, blast in pairs(blasts) do
		blast:update()
	end

	for key, bullet in pairs(bullets) do
		bullet:update()
	end

	ship:update()
end

function _draw()
	cls()
	for key, star in pairs(stars) do
		star:draw()
	end
	for key, blast in pairs(blasts) do
		blast:draw()
	end
	for key, bullet in pairs(bullets) do
		bullet:draw()
	end
	ship:draw()

	-- rect(0,0,127,127,15)

	-- print(#stars, 64, 64)
	-- print('fps:' .. stat(7), 6, 6)
	-- print('counter:' .. world.counter, 6, 12)
	print(ship.dx, 6, 6)
	print(ship.ddx, 6, 12)
	print(ship.dy, 6, 18)
	print(ship.ddy, 6, 24)
end
__gfx__
00000000000110000001100000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001cc100000cc000000cc00000a00a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700001cc100001cc100001cc100006006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700001c77c000017710000cc7c00000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700001c77c0001c77c0001c77c10066666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070001cc7c1001c7cc1001cccc10064444600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000101cc10000cc100000cc100060990600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000001000100010000000000060000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
