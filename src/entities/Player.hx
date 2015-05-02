package entities;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Text;

class Player {

    public var health : Int = 100;

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

    public function move(direction: Direction, entities: Array<Entity>) {

        var lastX = sprite.pos.x;
        var lastY = sprite.pos.y;

        if (direction == Direction.Up) {
            sprite.pos.y -= size;
        } else if (direction == Direction.Down) {
            sprite.pos.y += size;
        } else if (direction == Direction.Left) {
            sprite.pos.x -= size;
        } else if (direction == Direction.Right) {
            sprite.pos.x += size;
        }

        var collision = collide(entities);

        if (collision != null) {
            sprite.pos.x = lastX;
            sprite.pos.y = lastY;

            collision.collide(this);
        }

    }

    public function collide(entities: Array<Entity>) {

        var playerX1, playerY1, playerX2, playerY2 : Float;
        var entityX1, entityY1, entityX2, entityY2 : Float;

        for (entity in entities) {
            playerX1 = sprite.pos.x;
            playerY1 = sprite.pos.y;
            playerX2 = playerX1 + size;
            playerY2 = playerY1 + size;

            entityX1 = entity.getPosition().x;
            entityY1 = entity.getPosition().y;
            entityX2 = entityX1 + entity.getSize();
            entityY2 = entityY1 + entity.getSize();

            if (playerX1 < entityX2 && playerX2 > entityX1 && playerY1 < entityY2 && playerY2 > entityY1) {
                return entity;
            }
        }

        return null;

    }

    public function damage(amount: Int) {

        health -= amount;

        if (health < 1) {
            die();
        }

    }

    function die() {

        var message = new Text({
            immediate: false,
            pos: new Vector(Luxe.screen.w / 3, Luxe.screen.mid.y),
            text: 'Oh dear, you are dead!'
        });

    }

}
