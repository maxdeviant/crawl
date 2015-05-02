import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Text;

import entities.*;

class Main extends luxe.Game {

    var player : Player;
    var entities : Array<Entity> = new Array();

    override function ready() {

        Luxe.input.bind_key('up', Key.up);
        Luxe.input.bind_key('up', Key.key_w);

        Luxe.input.bind_key('down', Key.down);
        Luxe.input.bind_key('down', Key.key_s);

        Luxe.input.bind_key('left', Key.left);
        Luxe.input.bind_key('left', Key.key_a);

        Luxe.input.bind_key('right', Key.right);
        Luxe.input.bind_key('right', Key.key_d);

        Luxe.input.bind_key('character_sheet', Key.key_c);

        player = new Player(Luxe.screen.mid.x, Luxe.screen.mid.y);
        entities.push(new Enemy(Luxe.screen.mid.x + 64, Luxe.screen.mid.y));

    }

    override function onkeyup(event: KeyEvent) {

        if (event.keycode == Key.escape) {
            Luxe.shutdown();
        }

    }

    override function update(dt: Float) {

        if (Luxe.input.inputpressed('up')) {
            player.move(Direction.Up, entities);
        } else if (Luxe.input.inputpressed('down')) {
            player.move(Direction.Down, entities);
        } else if (Luxe.input.inputpressed('left')) {
            player.move(Direction.Left, entities);
        } else if (Luxe.input.inputpressed('right')) {
            player.move(Direction.Right, entities);
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
