package entities;

import luxe.Sprite;
import luxe.Rectangle;
import luxe.Color;
import luxe.Vector;

typedef Location = {
    x : Int,
    y : Int
};

class Entity {

    public var location : Location;

    public var sprite : Sprite;
    var SIZE : Int = 32;

    public function new(name: String, x: Int, y: Int, sheet_x: Int, sheet_y: Int) {

        location = {
            x: x,
            y: y
        };

        var map_x = x * SIZE;
        var map_y = y * SIZE;

        sprite = new Sprite({
            centered: false,
            name: name,
            pos: new Vector(map_x, map_y),
            texture: Luxe.resources.texture('assets/spritesheet.png'),
            uv: new Rectangle(sheet_x * SIZE, sheet_y * SIZE, SIZE, SIZE),
            color: new Color(1.0, 1.0, 1.0),
            size: new Vector(SIZE, SIZE)
        });

    }

    public function getPosition() {

        return sprite.pos;

    }

    public function getSize() {

        return SIZE;

    }

    public function collide(player: Player) {

    }

    public function damage(amount: Int) {

    }

}
