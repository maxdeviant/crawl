import map.*;
import entities.*;

class World {

    private static var instance : World = new World();

    private var map : Map;

    private var entities : Array<Entity>;

    private function new() {

        entities = new Array<Entity>();

    }

    public static function getInstance() {

        return instance;

    }

    public function setMap(map: Map) {

        this.map = map;

    }

    public function getMap() {

        return map;

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
