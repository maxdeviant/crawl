package entities;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Enemy {

    public var health : Int = 100;

    var sprite : Sprite;

    var size : Int = 32;

    public function new(x, y) {

        sprite = new Sprite({
            name: 'Enemy',
            pos: new Vector(x, y),
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

}
