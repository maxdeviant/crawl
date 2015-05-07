package hud;

import luxe.Log.*;

import luxe.Text;
import luxe.Vector;

class HealthBar extends HUDElement {

    private var health_bar : Text;

    public function new(x: Float, y: Float) {

        super('Health Bar');

        var health : Int = World.getInstance().getPlayer().health;

        health_bar = new Text({
            no_batcher_add: true,
            pos: new Vector(0, 0),
            text: 'HP: $health'
        });

        geometry = health_bar.geometry;

    }

    override public function update() {

        var health : Int = World.getInstance().getPlayer().health;

        health_bar.text = 'HP: $health';

    }

}
