package map;

class Room {

    public var x: Int;
    public var y: Int;
    public var width: Int;
    public var height: Int;

    public function new(x: Int, y: Int, width: Int, height: Int) {

        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;

    }

    public function getCenter() {

        return {
            x: Std.int((x + (x + width)) / 2),
            y: Std.int((y + (y + height)) / 2)
        };

    }

    public function intersects(room: Room) {

        var thisX1, thisY1, thisX2, thisY2 : Int;
        var otherX1, otherY1, otherX2, otherY2 : Int;

        thisX1 = x;
        thisY1 = y;
        thisX2 = x + width;
        thisY2 = y + height;

        otherX1 = room.x;
        otherY1 = room.y;
        otherX2 = room.x + room.width;
        otherY2 = room.y + room.height;

        return thisX1 < otherX2 && thisX2 > otherX1 && thisY1 < otherY2 && thisY2 > otherY1;

    }

}
