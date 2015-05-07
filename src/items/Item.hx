package items;

import luxe.Log.*;

import luxe.Sprite;
import luxe.Vector;
import luxe.Rectangle;
import phoenix.Texture;

class Item {

    var sprite : Sprite;
    var SIZE : Int = 32;

    public function new(name: String, x: Int, y: Int) {

        var map_x = x * SIZE;
        var map_y = y * SIZE;

        sprite = new Sprite({
            centered: false,
            name: name,
            pos: new Vector(map_x, map_y),
            texture: Luxe.resources.texture('assets/items.png'),
            uv: new Rectangle(0, 0, SIZE, SIZE),
            size: new Vector(SIZE, SIZE)
        });

        sprite.geometry.texture.filter_min = sprite.geometry.texture.filter_mag = phoenix.Texture.FilterType.nearest;

    }

}
