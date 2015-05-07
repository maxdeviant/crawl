import luxe.Log.*;

import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Text;
import phoenix.Batcher;
import phoenix.Camera;
import phoenix.Texture;

import hud.*;
import map.*;
import items.*;
import entities.*;

class Main extends luxe.Game {

    var hud : HUD;

    var world : World;

    var player : Player;

    override function config(config: luxe.AppConfig) {

        config.preload.textures.push({
            id: 'assets/tileset.png'
        });

        config.preload.textures.push({
            id: 'assets/spritesheet.png'
        });

        config.preload.textures.push({
            id: 'assets/items.png'
        });

        return config;

    }

    override function ready() {

        Luxe.renderer.clear_color = new Color(0.0, 0.0, 0.0);
        Luxe.camera.zoom = 2.5;

        Luxe.input.bind_key('up', Key.up);
        Luxe.input.bind_key('up', Key.key_w);

        Luxe.input.bind_key('down', Key.down);
        Luxe.input.bind_key('down', Key.key_s);

        Luxe.input.bind_key('left', Key.left);
        Luxe.input.bind_key('left', Key.key_a);

        Luxe.input.bind_key('right', Key.right);
        Luxe.input.bind_key('right', Key.key_d);

        world = World.getInstance();

        world.setMap(new Map('assets/tileset.png', 50, 50));

        var sprite_sheet = Luxe.resources.texture('assets/spritesheet.png');
        sprite_sheet.filter_min = sprite_sheet.filter_mag = FilterType.nearest;

        var item_sheet = Luxe.resources.texture('assets/items.png');
        item_sheet.filter_min = item_sheet.filter_mag = FilterType.nearest;

        var player_spawn = world.getMap().getPlayerSpawn();

        player = new Player(Std.int(player_spawn.x), Std.int(player_spawn.y));

        player.centerCamera();

        world.setPlayer(player);

        var item = new Item('Sword', Std.int(player_spawn.x) + 1, Std.int(player_spawn.y) + 1, item_sheet);

        hud = new HUD(Luxe.renderer);

        hud.register(new HealthBar(0, 0));

    }

    override function onkeydown(event: KeyEvent) {

        if (Luxe.input.inputpressed('up')) {
            player.move(Direction.Up);
        } else if (Luxe.input.inputpressed('down')) {
            player.move(Direction.Down);
        } else if (Luxe.input.inputpressed('left')) {
            player.move(Direction.Left);
        } else if (Luxe.input.inputpressed('right')) {
            player.move(Direction.Right);
        }

    }

    override function onkeyup(event: KeyEvent) {

        if (event.keycode == Key.escape) {
            Luxe.shutdown();
        }

    }

    override function update(dt: Float) {

    }

    override function onrender() {

        hud.updateAll();

    }

}
