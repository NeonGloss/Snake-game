import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {  //срабатывает когда все объекты на сцене были инициализированы и отображены
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill //растягиваем сцену на все доступное место
        skView.presentScene(scene)
        
    }


}
