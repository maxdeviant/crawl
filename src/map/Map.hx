package map;

import luxe.Rectangle;
import phoenix.Batcher;
import phoenix.geometry.QuadPackGeometry;

class Map {

    private var tile_width : Int = 32;
    private var tile_height : Int = 32;

    private var tile_batcher : Batcher;
    private var geometry : QuadPackGeometry;

    private var tiles : Array<Array<Tile>>;

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

    }

    public function getTile(x: Int, y: Int) {

        try {
            return tiles[x][y];
        } catch (e: Dynamic) {
            return null;
        }

    }

    private function generate(width: Int, height: Int) {

        var map_tiles = new Array<Array<Tile>>();

        for (y in 0 ... height) {
            var row = new Array<Tile>();

            for (x in 0 ... width) {
                var map_x = x * tile_width;
                var map_y = y * tile_height;

                var quad = geometry.quad_add({
                    x: map_x,
                    y: map_y,
                    w: tile_width,
                    h: tile_height
                });

                var tile_x : Int;
                var tile_y : Int;
                var solid : Bool;

                if (x == 0 || y == 0 || x == width - 1 || y == height - 1) {
                    tile_x = 1;
                    tile_y = 0;
                    solid = true;
                } else {
                    tile_x = 0;
                    tile_y = 0;
                    solid = false;
                }

                geometry.quad_uv(quad, new Rectangle((tile_x * tile_width), (tile_y * tile_height), tile_width, tile_height));

                row.push(new Tile(quad, tile_x, tile_y, solid));
            }

            map_tiles.push(row);
        }

        return map_tiles;

    }

}
