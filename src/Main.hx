import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Text;
import phoenix.Batcher;
import phoenix.Camera;

import map.*;
import entities.*;

class Main extends luxe.Game {

    var hud_batcher : Batcher;

    var health_bar : Text;

    var player : Player;
    var entities : Array<Entity> = new Array();

    override function config(config: luxe.AppConfig) {

        config.preload.textures.push({
            id: 'assets/tileset.png'
        });

        return config;

    }

    override function ready() {

        hud_batcher = Luxe.renderer.create_batcher({
            name: 'hud',
            camera: new Camera(),
            layer: 2
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

        World.getInstance().setMap(new Map('assets/tileset.png', 50, 50));

        var player_spawn = World.getInstance().getMap().getPlayerSpawn();

        player = new Player(Std.int(player_spawn.x), Std.int(player_spawn.y));

        player.centerCamera();

        World.getInstance().register(new Enemy(10, 10));

        health_bar = new Text({
            no_batcher_add: true,
            pos: new Vector(0, 0),
            text: 'HP: ' + player.health
        });

        hud_batcher.add(health_bar.geometry);

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

    }

    override function onrender() {

        health_bar.text = 'HP: ' + player.health;

    }

    function openCharacterSheet() {

        var background = Luxe.draw.box({
            immediate: true,
            batcher: hud_batcher,
            x: Luxe.screen.w / 10,
            y: Luxe.screen.h / 10,
            w: Luxe.screen.w - 2 * (Luxe.screen.w / 10),
            h: Luxe.screen.h - 2 * (Luxe.screen.h / 10),
            color: new Color().rgb(0x2e2e2e)
        });

        var text = new Text({
            immediate: true,
            no_batcher_add: true,
            pos: new Vector(Luxe.screen.w / 10 + 10, Luxe.screen.h / 10 + 10),
            text: 'POW: ' + player.power
        });

        hud_batcher.add(text.geometry);

    }

}
