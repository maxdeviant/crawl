package entities;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Player {

    var sprite : Sprite;

    var size : Int = 32;

    public function new(x, y) {
        sprite = new Sprite({
            name: 'Player',
            pos: new Vector(x, y),
            color: new Color().rgb(0xf94b04),
            size: new Vector(size, size)
        });
    }

    public function move(direction: Direction) {

        if (direction == Direction.Up) {
            sprite.pos.y -= size;
        } else if (direction == Direction.Down) {
            sprite.pos.y += size;
        } else if (direction == Direction.Left) {
            sprite.pos.x -= size;
        } else if (direction == Direction.Right) {
            sprite.pos.x += size;
        }

    }

}