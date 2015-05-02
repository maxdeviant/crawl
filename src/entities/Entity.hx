package entities;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Entity {

    var sprite : Sprite;
    var size : Int = 32;

    public function new(name: String, pos: Vector, color: Color) {

        sprite = new Sprite({
            name: name,
            pos: pos,
            color: color,
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

    public function damage(amount: Int) {

    }

}
