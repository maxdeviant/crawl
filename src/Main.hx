import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Rectangle;
import luxe.Text;
import phoenix.Batcher;
import phoenix.geometry.QuadPackGeometry;

import entities.*;

typedef MapTile = {
    quad : Int,
    tile_x: Int,
    tile_y : Int
};

class Main extends luxe.Game {

    var tile_batcher : Batcher;
    var entity_batcher : Batcher;

    var player : Player;
    var entities : Array<Entity> = new Array();

    var geometry : QuadPackGeometry;
    var map_tiles : Array<Array<MapTile>>;

    override function config(config: luxe.AppConfig) {

        config.preload.textures.push({
            id: 'assets/tileset.png'
        });

        return config;

    }

    override function ready() {

        tile_batcher = Luxe.renderer.create_batcher({
            name: 'background',
            layer: 0
        });

        Luxe.input.bind_key('up', Key.up);
        Luxe.input.bind_key('up', Key.key_w);

        Luxe.input.bind_key('down', Key.down);
        Luxe.input.bind_key('down', Key.key_s);

        Luxe.input.bind_key('left', Key.left);
        Luxe.input.bind_key('left', Key.key_a);

        Luxe.input.bind_key('right', Key.right);
        Luxe.input.bind_key('right', Key.key_d);

        Luxe.input.bind_key('character_sheet', Key.key_c);

        geometry = new QuadPackGeometry({
            texture: Luxe.resources.texture('assets/tileset.png'),
            batcher: tile_batcher
        });

        geometry.texture.filter_min = geometry.texture.filter_mag = phoenix.Texture.FilterType.nearest;

        map_tiles = new Array<Array<MapTile>>();

        var size = 32;
        var tile_count_x = Std.int(Luxe.screen.w / size);
        var tile_count_y = Std.int(Luxe.screen.h / size);

        for (y in 0 ... tile_count_y) {
            var row = new Array<MapTile>();

            for (x in 0 ... tile_count_x) {
                var map_x = x * size;
                var map_y = y * size;

                var quad = geometry.quad_add({
                    x: map_x,
                    y: map_y,
                    w: size,
                    h: size
                });

                var tile_x : Int;
                var tile_y : Int;

                if (x == 0 || y == 0 || x == tile_count_x - 1 || y == tile_count_y - 1) {
                    tile_x = 1;
                    tile_y = 0;
                } else {
                    tile_x = 0;
                    tile_y = 0;
                }

                geometry.quad_uv(quad, new Rectangle((tile_x * size), (tile_y * size), size, size));

                row.push({
                    quad: quad,
                    tile_x: tile_x,
                    tile_y: tile_y
                });
            }

            map_tiles.push(row);
        }

        player = new Player(0, 0);

        World.getInstance().register(new Enemy(1, 1));

    }

    override function onkeyup(event: KeyEvent) {

        if (event.keycode == Key.escape) {
            Luxe.shutdown();
        }

    }

    override function update(dt: Float) {

        if (Luxe.input.inputpressed('up')) {
            player.move(Direction.Up);
        } else if (Luxe.input.inputpressed('down')) {
            player.move(Direction.Down);
        } else if (Luxe.input.inputpressed('left')) {
            player.move(Direction.Left);
        } else if (Luxe.input.inputpressed('right')) {
            player.move(Direction.Right);
        }

        if (Luxe.input.inputdown('character_sheet')) {
            openCharacterSheet();
        }

        var text = new Text({
            immediate: true,
            pos: new Vector(0, 0),
            text: 'HP: ' + player.health
        });

    }

    function openCharacterSheet() {

        var background = Luxe.draw.box({
            immediate: true,
            x: Luxe.screen.w / 10,
            y: Luxe.screen.h / 10,
            w: Luxe.screen.w - 2 * (Luxe.screen.w / 10),
            h: Luxe.screen.h - 2 * (Luxe.screen.h / 10),
            color: new Color().rgb(0x2e2e2e)
        });

        var text = new Text({
            immediate: true,
            pos: new Vector(Luxe.screen.w / 10 + 10, Luxe.screen.h / 10 + 10),
            text: 'POW: ' + player.power
        });

    }

}
