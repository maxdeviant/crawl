package map;

class Tile {

    private var quad : Int;
    private var x : Int;
    private var y : Int;
    private var solid : Bool;

    public function new(quad: Int, x: Int, y: Int, solid: Bool) {

        this.quad = quad;
        this.x = x;
        this.y = y;
        this.solid = solid;

    }

    public function isSolid() {

        return solid;

    }

}
