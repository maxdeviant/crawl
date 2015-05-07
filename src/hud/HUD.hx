package hud;

import luxe.Log.*;

import phoenix.Camera;
import phoenix.Batcher;
import phoenix.Renderer;
import phoenix.geometry.Geometry;

class HUD {

    private var batcher : Batcher;

    public var elements : Map<String, HUDElement>;

    public function new(renderer: Renderer) {

        log('[HUD] Initialising');

        batcher = renderer.create_batcher({
            name: 'hud',
            camera: new Camera(),
            layer: 2
        });

        elements = new Map<String, HUDElement>();

    }

    public function register(element: HUDElement) {

        elements.set(element.id, element);

        batcher.add(element.geometry);

        log('[HUD] Registered "${element.id}"');

    }

    public function update(id: String) {

        var element = elements.get(id);

        element.update();

        log('[HUD] Updated "${element.id}"');

    }

    public function updateAll() {

        for (element in elements) {

            element.update();

            // log('[HUD] Updated "${element.id}"');

        }

    }

}
