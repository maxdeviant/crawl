package entities;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Text;

typedef Location = {
    x : Int,
    y : Int
};

class Player extends Entity {

    public var location : Location;

    public var fov : Int = 5;

    public var health : Int = 100;
    public var power : Int = 10;
    public var luck : Int = 0;

    public function new(x: Int, y: Int) {

        super('Player', x, y, 0, 0);

        location = {
            x: x,
            y: y
        };

        World.getInstance().getMap().computeFOV(location.x, location.y, fov);

    }

    override function damage(amount: Int) {

        health -= amount;

        if (health < 1) {
            die();
        }

    }

    public function move(direction: Direction) {

        var lastX = location.x;
        var lastY = location.y;

        if (direction == Direction.Up) {
            location.y -= 1;
        } else if (direction == Direction.Down) {
            location.y += 1;
        } else if (direction == Direction.Left) {
            location.x -= 1;
        } else if (direction == Direction.Right) {
            location.x += 1;
        }

        sprite.pos = new Vector(location.x * SIZE, location.y * SIZE);

        var blocked = isBlocked();

        if (blocked) {
            location.x = lastX;
            location.y = lastY;

            sprite.pos = new Vector(lastX * SIZE, lastY * SIZE);
        }

        centerCamera();
        World.getInstance().getMap().computeFOV(location.x, location.y, fov);

        var collision = isColliding();

        if (collision != null) {
            location.x = lastX;
            location.y = lastY;

            sprite.pos = new Vector(lastX * SIZE, lastY * SIZE);

            centerCamera();
            World.getInstance().getMap().computeFOV(location.x, location.y, fov);

            collision.collide(this);
        }

    }

    public function centerCamera() {

        Luxe.camera.focus(sprite.pos, 1);

    }

    public function attack(target: Entity) {

        target.damage(power);

    }

    private function isBlocked() {

        var tile = World.getInstance().getMap().getTile(location.x, location.y);

        if (tile == null) {
            return false;
        }

        return tile.isSolid();

    }

    private function isColliding() {

        var playerX1, playerY1, playerX2, playerY2 : Float;
        var entityX1, entityY1, entityX2, entityY2 : Float;

        var entities : Array<Entity> = World.getInstance().getEntities();

        for (entity in entities) {
            playerX1 = sprite.pos.x;
            playerY1 = sprite.pos.y;
            playerX2 = playerX1 + SIZE;
            playerY2 = playerY1 + SIZE;

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
