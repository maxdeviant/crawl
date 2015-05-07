package map;

import luxe.Log.*;

class Tile {

    public var quad_id : Int;

    private var sheet_x : Int;
    private var sheet_y : Int;
    private var solid : Bool;
    private var explored : Bool;
    private var visible : Bool;

    public function new(quad_id: Int, sheet_x: Int, sheet_y: Int, solid: Bool) {

        this.quad_id = quad_id;
        this.sheet_x = sheet_x;
        this.sheet_y = sheet_y;
        this.solid = solid;
        this.explored = false;
        this.visible = false;

    }

    public function isSolid() {

        return solid;

    }

    public function isExplored() {

        return explored;

    }

    public function explore() {

        explored = true;

    }

    public function isVisible() {

        return visible;

    }

    public function setVisible(visible: Bool) {

        this.visible = visible;

    }

}
