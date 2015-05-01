package entities;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Entity {

    var sprite : Sprite;
    var size : Int = 32;

    public function new(name, pos, color) {

        sprite = new Sprite({
            name: 'Enemy',
            pos: pos,
            color: new Color().rgb(0xe32636),
            size: new Vector(size, size)
        });

    }

    public function getPosition() {

        return sprite.pos;

    }

    public function getSize() {

        return size;

    }

    public function collide(player: Player) {

    }

}
