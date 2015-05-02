package entities;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Log.log;

class Enemy extends Entity {

    public var health : Int = 100;
    public var power : Int = 10;

    public function new(x: Float, y: Float) {

        super('Enemy', new Vector(x , y), new Color().rgb(0xe32636));

    }

    override function collide(player: Player) {

        player.attack(this);

        attack(player);

    }

    public function attack(target: Entity) {

        target.damage(power);

    }

    override public function damage(amount: Int) {

        health -= amount;

        if (health < 1) {
            die();
        }

    }

    function die() {

        log('This enemy has died');

    }

}
