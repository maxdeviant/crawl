import luxe.Log.*;

import map.*;
import entities.*;

class World {

    private static var instance : World = new World();

    private var map : Map;

    private var exit : Location;

    private var player : Player;
    private var entities : Array<Entity>;

    private function new() {

        entities = new Array<Entity>();

    }

    public static function getInstance() {

        return instance;

    }

    public function reset() {

        for (entity in entities) {
            entity.sprite.destroy();
        }

        entities.splice(0, entities.length);

        generateMap();

        player.teleport(map.getPlayerSpawn());

    }

    public function generateMap() {

        map = new Map(50, 50);

    }

    public function setMap(map: Map) {

        this.map = map;

    }

    public function getMap() {

        return map;

    }

    public function setPlayer(player: Player) {

        this.player = player;

    }

    public function getPlayer() {

        return player;

    }

    public function setExit(exit: Location) {

        this.exit = exit;

    }

    public function getExit() {

        return exit;

    }

    public function getEntities() {

        return entities;

    }

    public function register(entity : Entity) {

        entities.push(entity);

    }

    public function unregister(entity : Entity) {

        entities.remove(entity);

    }

}
