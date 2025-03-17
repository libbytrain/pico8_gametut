pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	game_over=false
	make_tubes()
	make_coins()
	make_clouds()
	init_player()
end

function _update()
	if not game_over then
		update_tubes()
		update_coins()
		update_clouds()
		move_player()
		check_collision()
		check_coin_collection()
	end
end

function _draw()
	cls(12)
	draw_clouds()
	draw_tubes()
	draw_coins()
	draw_player()
	print("coins: "..player.coins, 5, 5, 7)
	rectfill(0, 0, 127, 4, 3)    
	rectfill(0, 123, 127, 127, 3) 
end

-->8
function init_player()
	player={}
	player.x=24   --position
	player.y=60
	player.dy=0   --fall speed
	player.still=1
	player.jump=2
	player.dead=3
	player.speed=2
	player.coins=0
end

function draw_player()
	if (game_over) then
		spr(player.dead,player.x,player.y)	
	elseif (player.dy<0) then
		spr(player.jump,player.x,player.y)
	else
		spr(player.still,player.x,player.y)
	end	
end

function move_player()
	gravity=0.3
	player.dy+=gravity
	
	if(btnp(2)) then
		player.dy-=3
		sfx(0)
	end
	
	player.y+=player.dy
end

function check_collision()
	for tube in all(tubes) do
		if player.x + 7 > tube.x and player.x < tube.x + 15 then
			if player.y < tube.top_height or player.y + 7 > tube.bottom_height then
				game_over = true
				sfx(2)
			end
		end
	end

	if player.y <= 4 or player.y + 7 >= 123 then
		game_over = true
		sfx(2)
	end
end

-->8
function make_tubes()
	tubes={}
	spawn_tube()
end

function spawn_tube()
	local gap_size = 50  
	local gap_y = flr(rnd(60)) + 30

	local tube = {
		x=128, 
		top_height=gap_y,
		bottom_height=gap_y + gap_size
	}

	add(tubes, tube)


	spawn_coin(tube)
end


function update_tubes()
	for tube in all(tubes) do
		tube.x -= 2
		if tube.x < -20 then
			del(tubes, tube)
			spawn_tube()
		end
	end
end

function draw_tubes()
	for tube in all(tubes) do
		rectfill(tube.x, 0, tube.x + 15, tube.top_height, 11)
		rectfill(tube.x, tube.bottom_height, tube.x + 15, 127, 11)
	end
end
-->8
function make_coins()
	coins={}
end

function spawn_coin(tube)
	local coin = {
		x = tube.x + 8, 
		y = tube.top_height + 10,
		sprite = 4,
		frame = 0
	}
	add(coins, coin)
end


function update_coins()
	for coin in all(coins) do
		coin.x -= 2
		coin.frame += 1
		if (coin.frame % 10 < 5) then
			coin.sprite = 4
		else
			coin.sprite = 5
		end
		if coin.x < -8 then
			del(coins, coin)
		end
	end
end

function draw_coins()
	for coin in all(coins) do
		spr(coin.sprite, coin.x, coin.y)
	end
end

function check_coin_collection()
	for coin in all(coins) do
		if abs(player.x - coin.x) < 6 and abs(player.y - coin.y) < 6 then
			player.coins += 1
			sfx(1)
			del(coins, coin)
		end
	end
end

-->8
function make_clouds()
	clouds = {}
	for i = 1, 3 do
		add(clouds, {
			x = rnd(128), 
			y = rnd(50), 
			speed = 0.5 + rnd(1)
		})
	end
end

function update_clouds()
	for cloud in all(clouds) do
		cloud.x -= cloud.speed
		if cloud.x < -16 then
			cloud.x = 128
			cloud.y = rnd(50)
		end
	end
end

function draw_clouds()
	for cloud in all(clouds) do
		circfill(cloud.x, cloud.y, 4, 6) 
		circfill(cloud.x + 3, cloud.y + 1, 3, 6)
		circfill(cloud.x - 3, cloud.y + 1, 3, 6)
	end
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000440000004400000000000000990000009900000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000ff000000ff00000000000009999000009900000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000bb00000bbb00000000000099aa9900009900000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000bb0000b0bbb0000000000099aa9900009900000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000330000003300004fbb330009999000009900000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000330000030030004fbb330000990000009900000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000015750187501c7502075000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000024550345500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000013550105500c5500655004550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
