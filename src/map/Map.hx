package map;

import luxe.Vector;
import luxe.Rectangle;
import phoenix.Batcher;
import phoenix.geometry.QuadPackGeometry;

typedef SpawnPoint = {
    x: Int,
    y: Int
};

class Map {

    private var TILE_WIDTH : Int = 32;
    private var TILE_HEIGHT : Int = 32;

    private var tile_batcher : Batcher;
    private var geometry : QuadPackGeometry;

    private var tiles : Array<Array<Tile>>;

    private var player_spawn : SpawnPoint;

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
                    h: TILE_HEIGHT
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
                    h: TILE_HEIGHT
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
                h: TILE_HEIGHT
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
                h: TILE_HEIGHT
            });

            var sheet_x = 0;
            var sheet_y = 0;
            var solid = false;

            geometry.quad_uv(quad, new Rectangle(sheet_x * TILE_WIDTH, sheet_y * TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT));

            tiles[y][x] = new Tile(quad, sheet_x, sheet_y, solid);
        }

    }

}
