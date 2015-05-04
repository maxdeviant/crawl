package map;

import luxe.Color;
import luxe.Vector;
import luxe.Rectangle;
import phoenix.Batcher;
import phoenix.geometry.QuadPackGeometry;

import entities.Enemy;

typedef Location = {
    x: Int,
    y: Int
};

class Map {

    private var TILE_WIDTH : Int = 32;
    private var TILE_HEIGHT : Int = 32;

    private var UNEXPLORED : Color = new Color(0.0, 0.0, 0.0);
    private var EXPLORED : Color = new Color(0.5, 0.5, 0.5);
    private var VISIBLE : Color = new Color(1.0, 1.0, 1.0);

    private var tile_batcher : Batcher;
    private var geometry : QuadPackGeometry;

    private var tiles : Array<Array<Tile>>;

    private var player_spawn : Location;

    public function new(spritesheet: String, width: Int, height: Int) {

        tile_batcher = Luxe.renderer.create_batcher({
            name: 'tile',
            camera: Luxe.camera.view,
            layer: 0
        });

        geometry = new QuadPackGeometry({
            texture: Luxe.resources.texture(spritesheet),
            batcher: tile_batcher
        });

        geometry.texture.filter_min = geometry.texture.filter_mag = phoenix.Texture.FilterType.nearest;
        geometry.locked = true;

        tiles = generate(width, height);

        var MAX_ROOMS = 25;
        var MIN_ROOM_SIZE = 3;
        var MAX_ROOM_SIZE = 12;

        var rooms = new Array<Room>();

        for (room in 0 ... MAX_ROOMS) {
            var room_width = Math.floor(Math.random() * (MAX_ROOM_SIZE - MIN_ROOM_SIZE)) + MIN_ROOM_SIZE;
            var room_height = Math.floor(Math.random() * (MAX_ROOM_SIZE - MIN_ROOM_SIZE)) + MIN_ROOM_SIZE;

            var x = Math.floor(Math.random() * (width - room_width - 2) + 1);
            var y = Math.floor(Math.random() * (height - room_height - 2) + 1);

            var new_room = new Room(x, y, room_width, room_height);

            var failed = false;

            for (other_room in rooms) {
                if (new_room.intersects(other_room)) {
                    failed = true;
                    break;
                }
            }

            if (failed) {
                continue;
            }

            createRoom(x, y, room_width, room_height);

            if (room == 0) {
                player_spawn = new_room.getCenter();
            } else {
                connectRooms(rooms[rooms.length - 1], new_room);
            }

            rooms.push(new_room);
        }

        populate(rooms);

    }

    public function getTile(x: Int, y: Int) {

        try {
            return tiles[y][x];
        } catch (e: Dynamic) {
            return null;
        }

    }

    public function getPlayerSpawn() {

        return player_spawn;

    }

    public function computeFOV(player_x: Int, player_y: Int, fov: Int) {

        var multipliers : Array<Array<Int>> = [
            [1,  0,  0, -1, -1,  0,  0,  1],
            [0,  1, -1,  0,  0, -1,  1,  0],
            [0,  1,  1,  0,  0, -1, -1,  0],
            [1,  0,  0,  1, -1,  0,  0, -1]
        ];

        for (y in 0 ... tiles.length) {
            for (x in 0 ... tiles[y].length) {
                tiles[y][x].setVisible(false);

                if (tiles[y][x].isExplored()) {
                    geometry.quad_color(tiles[y][x].quad_id, EXPLORED);
                } else {
                    geometry.quad_color(tiles[y][x].quad_id, UNEXPLORED);
                }
            }
        }

        tiles[player_y][player_x].explore();
        geometry.quad_color(tiles[player_y][player_x].quad_id, VISIBLE);

        for (octant in 0 ... 8) {
            castLight(player_x, player_y, 1, 1.0, 0.0, fov, multipliers[0][octant], multipliers[1][octant], multipliers[2][octant], multipliers[3][octant], 0);
        }

        for (entity in World.getInstance().getEntities()) {
            var tile = tiles[entity.location.y][entity.location.x];

            if (tile.isVisible()) {
                entity.sprite.visible = true;
            } else {
                entity.sprite.visible = false;
            }
        }

        geometry.dirty = true;

    }

    private function castLight(cx: Int, cy: Int, row: Int, light_start: Float, light_end: Float, radius: Int, xx: Int, xy: Int, yx: Int, yy: Int, id: Int) {

        var new_start : Float = 0.0;

        if (light_start < light_end) {
            return;
        }

        var radius_sq = radius * radius;

        for (j in row ... radius) {
            var dx = -j - 1;
            var dy = -j;

            var blocked = false;

            while (dx <= 0) {
                dx += 1;

                var mx = cx + dx * xx + dy * xy;
                var my = cy + dx * yx + dy * yy;

                var l_slope = (dx - 0.5) / (dy + 0.5);
                var r_slope = (dx + 0.5) / (dy - 0.5);

                if (light_start < r_slope) {
                    continue;
                } else if (light_end > l_slope) {
                    break;
                } else {
                    if (dx * dx + dy * dy < radius_sq) {
                        tiles[my][mx].explore();
                        tiles[my][mx].setVisible(true);
                        geometry.quad_color(tiles[my][mx].quad_id, VISIBLE);
                    }

                    if (blocked) {
                        if (tiles[my][mx].isSolid()) {
                            new_start = r_slope;
                            continue;
                        } else {
                            blocked = false;
                            light_start = new_start;
                        }
                    } else {
                        if (tiles[my][mx].isSolid() && j < radius) {
                            blocked = true;

                            castLight(cx, cy, j + 1, light_start, l_slope, radius, xx, xy, yx, yy, id + 1);

                            new_start = r_slope;
                        }
                    }
                }
            }

            if (blocked) {
                break;
            }
        }

    }

    private function generate(width: Int, height: Int) {

        var map_tiles = new Array<Array<Tile>>();

        for (y in 0 ... height) {
            var row = new Array<Tile>();

            for (x in 0 ... width) {
                var map_x = x * TILE_WIDTH;
                var map_y = y * TILE_HEIGHT;

                var quad = geometry.quad_add({
                    x: map_x,
                    y: map_y,
                    w: TILE_WIDTH,
                    h: TILE_HEIGHT,
                    color: EXPLORED
                });

                var sheet_x : Int;
                var sheet_y : Int;
                var solid : Bool;

                sheet_x = 1;
                sheet_y = 0;
                solid = true;

                geometry.quad_uv(quad, new Rectangle(sheet_x * TILE_WIDTH, sheet_y * TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT));

                row.push(new Tile(quad, sheet_x, sheet_y, solid));
            }

            map_tiles.push(row);
        }

        return map_tiles;

    }

    private function populate(rooms: Array<Room>) {

        var MIN_ENEMIES = 1;
        var MAX_ENEMIES = 4;

        var room_number = 0;

        for (room in rooms) {
            room_number++;

            var num_enemies = Math.floor(Math.random() * (MAX_ENEMIES - MIN_ENEMIES)) + MIN_ENEMIES;

            for (enemy in 0 ... num_enemies) {
                var x : Int;
                var y : Int;

                do {
                    x = Math.floor(Math.random() * ((room.x + room.width) - room.x) + room.x);
                    y = Math.floor(Math.random() * ((room.y + room.height) - room.y) + room.y);
                }  while (tiles[y][x].isSolid());

                World.getInstance().register(new Enemy('Guard ' + room_number + '.' + enemy, x, y));
            }
        }

    }

    private function createRoom(x1: Int, y1: Int, width: Int, height: Int) {

        for (y in y1 ... y1 + height + 1) {
            for (x in x1 ... x1 + width + 1) {
                geometry.quad_remove(tiles[y][x].quad_id);

                var map_x = x * TILE_WIDTH;
                var map_y = y * TILE_HEIGHT;

                var quad = geometry.quad_add({
                    x: map_x,
                    y: map_y,
                    w: TILE_WIDTH,
                    h: TILE_HEIGHT,
                    color: EXPLORED
                });

                var sheet_x = 0;
                var sheet_y = 0;
                var solid = false;

                geometry.quad_uv(quad, new Rectangle(sheet_x * TILE_WIDTH, sheet_y * TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT));

                tiles[y][x] = new Tile(quad, sheet_x, sheet_y, solid);
            }
        }

    }

    private function connectRooms(room_a: Room, room_b: Room) {

        var old_room = room_a.getCenter();
        var new_room = room_b.getCenter();

        var order = Math.round(Math.random());

        if (order == 0) {
            createHorizontalTunnel(old_room.x, new_room.x, old_room.y);
            createVerticalTunnel(old_room.y, new_room.y, new_room.x);
        } else {
            createVerticalTunnel(old_room.y, new_room.y, old_room.x);
            createHorizontalTunnel(old_room.x, new_room.x, new_room.y);
        }

    }

    private function createHorizontalTunnel(start_x: Int, end_x: Int, y: Int) {

        var min : Int = Std.int(Math.min(start_x, end_x));
        var max : Int = Std.int(Math.max(start_x, end_x) + 1);

        for (x in min ... max) {
            geometry.quad_remove(tiles[y][x].quad_id);

            var map_x = x * TILE_WIDTH;
            var map_y = y * TILE_HEIGHT;

            var quad = geometry.quad_add({
                x: map_x,
                y: map_y,
                w: TILE_WIDTH,
                h: TILE_HEIGHT,
                color: EXPLORED
            });

            var sheet_x = 0;
            var sheet_y = 0;
            var solid = false;

            geometry.quad_uv(quad, new Rectangle(sheet_x * TILE_WIDTH, sheet_y * TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT));

            tiles[y][x] = new Tile(quad, sheet_x, sheet_y, solid);
        }

    }

    private function createVerticalTunnel(start_y: Int, end_y: Int, x: Int) {

        var min : Int = Std.int(Math.min(start_y, end_y));
        var max : Int = Std.int(Math.max(start_y, end_y) + 1);

        for (y in min ... max) {
            geometry.quad_remove(tiles[y][x].quad_id);

            var map_x = x * TILE_WIDTH;
            var map_y = y * TILE_HEIGHT;

            var quad = geometry.quad_add({
                x: map_x,
                y: map_y,
                w: TILE_WIDTH,
                h: TILE_HEIGHT,
                color: EXPLORED
            });

            var sheet_x = 0;
            var sheet_y = 0;
            var solid = false;

            geometry.quad_uv(quad, new Rectangle(sheet_x * TILE_WIDTH, sheet_y * TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT));

            tiles[y][x] = new Tile(quad, sheet_x, sheet_y, solid);
        }

    }

}
