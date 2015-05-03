package items;

import luxe.Sprite;
import luxe.Vector;
import luxe.Rectangle;
import phoenix.Texture;

class Item {

    var sprite : Sprite;
    var size : Int = 32;

    public function new(name: String, x: Int, y: Int, texture: Texture) {

        var map_x = x * size;
        var map_y = y * size;

        sprite = new Sprite({
            centered: false,
            name: name,
            pos: new Vector(map_x, map_y),
            texture: texture,
            uv: new Rectangle(0, 0, size, size),
            size: new Vector(size, size)
        });

    }

}
