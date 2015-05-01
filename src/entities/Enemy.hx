package entities;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Enemy extends Entity {

    public var health : Int = 100;

    public function new(x, y) {

        super('Enemy', new Vector(x , y), new Color().rgb(0xe32636));

    }

    override function collide(player: Player) {

        player.damage(10);

    }

}
