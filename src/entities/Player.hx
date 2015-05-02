package entities;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Text;

class Player extends Entity {

    public var health : Int = 100;
    public var power : Int = 10;
    public var luck : Int = 0;

    public function new(x: Int, y: Int) {

        super('Player', x, y, new Color().rgb(0xf94b04));

    }

    override function damage(amount: Int) {

        health -= amount;

        if (health < 1) {
            die();
        }

    }

    public function move(direction: Direction) {

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

        centerCamera();

        var collision = isColliding();

        if (collision != null) {
            sprite.pos.x = lastX;
            sprite.pos.y = lastY;

            centerCamera();

            collision.collide(this);
        }

    }

    public function centerCamera() {

        Luxe.camera.pos = sprite.pos.clone().subtract(Luxe.screen.mid);

    }

    public function attack(target: Entity) {

        target.damage(power);

    }

    private function isColliding() {

        var playerX1, playerY1, playerX2, playerY2 : Float;
        var entityX1, entityY1, entityX2, entityY2 : Float;

        var entities : Array<Entity> = World.getInstance().getEntities();

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

    private function die() {

        var message = new Text({
            immediate: false,
            pos: new Vector(Luxe.screen.w / 3, Luxe.screen.mid.y),
            text: 'Oh dear, you are dead!'
        });

    }

}
