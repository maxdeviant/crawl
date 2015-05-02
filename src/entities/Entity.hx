package entities;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Entity {

    var sprite : Sprite;
    var size : Int = 32;

    public function new(name: String, x: Int, y: Int, color: Color) {

        var map_x = x * size;
        var map_y = y * size;

        sprite = new Sprite({
            centered: false,
            name: name,
            pos: new Vector(map_x, map_y),
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
