import entities.*;

class World {

    private static var instance : World = new World();

    private var entities : Array<Entity> = new Array();

    public static function getInstance() {

        return instance;

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
