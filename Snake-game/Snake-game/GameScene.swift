import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var snake: Snake?
    
    override func didMove(to view: SKView) {  //инициализация стартового "экрана"
        backgroundColor = SKColor.black
        physicsWorld.gravity = CGVector(dx: 0, dy: 0) //обработка физики в данной сцене
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame) // определяем что физика в данной сцене будет действовать внутри frame
        physicsBody?.allowsRotation = false
        view.showsPhysics = true  // отображение отладочной информации в консоль
        physicsWorld.contactDelegate = self
        
        // определим объекты с которыми необходимо обрабатывать соприкосание
        physicsBody?.categoryBitMask = CollisionCategories.ScreenBody  // определяет то чем будет являться наш объект(а именно: игровая сцена будет являться объектом ScreenBody)
        physicsBody?.collisionBitMask = CollisionCategories.Snake | CollisionCategories.SnakeHead //определяет то с чем будет взаимодействовать наша сцена( с змеей или с головой змеи) и когда это будет происходить будет активироваться DIDBEGIN из SKPhysicsContactDelegate-а, котормы мы объявили себя
        
        // Node - это понятие сущьности размещенной на экране
        
        //создаем ноду кнопки #1
        let counterClockwiseButton = SKShapeNode()
        counterClockwiseButton.path =  UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath   //создаем форму для кнопки
        counterClockwiseButton.position = CGPoint(x: view.scene!.frame.minX + 30, y: view.scene!.frame.minY + 30)
        counterClockwiseButton.fillColor = UIColor.orange
        counterClockwiseButton.name = "counterClockwiseButton"
        //добавляем ноду кнопки на сцену
        self.addChild(counterClockwiseButton)
        
        //создаем ноду кнопки #2
        let clockwiseButton = SKShapeNode()
        clockwiseButton.path =  UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath   //создаем форму для кнопки
        clockwiseButton.position = CGPoint(x: view.scene!.frame.maxX - 80, y: view.scene!.frame.minY + 30)
        clockwiseButton.fillColor = UIColor.orange
        clockwiseButton.name = "clockwiseButton"
        //добавляем ноду кнопки на сцену
        self.addChild(clockwiseButton)
        
        putAppleAtRandomPlace()
        snake = Snake(atPoint: CGPoint(x: view.scene!.frame.midX, y: view.scene!.frame.midY))
        addChild(snake!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {  //как только коснулись экрана - запускается этот метод
        for touch in touches {
            let touchLocaiton = touch.location(in: self)  // возвращает абсолютные координаты относительно текущей сцены
                
            guard let touchesNode = self.atPoint(touchLocaiton) as? SKShapeNode,  touchesNode.name == "clockwiseButton" || touchesNode.name == "counterClockwiseButton" else {// возвращает ту ноду которая находится в данной точке
                return
            }
            touchesNode.fillColor = SKColor.blue  // меняем цвет кнопки при нажатии
            if touchesNode.name == "counterClockwiseButton" {
                snake?.moveCounterClockwise()
            }
            
            if touchesNode.name == "clockwiseButton" {
                snake?.moveClockwise()
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {  //запускается когда мы убираем палец с экрана
        for touch in touches {
            let touchLocaiton = touch.location(in: self)  // возвращает абсолютные координаты относительно текущей сцены
            
            guard let touchesNode = self.atPoint(touchLocaiton) as? SKShapeNode, touchesNode.name == "clockwiseButton" || touchesNode.name == "counterClockwiseButton" else { // возвращает ту ноду которая находится в данной точке
                return
            }
            touchesNode.fillColor = SKColor.orange  // меняем цвет обратно при убирании пальца с экрана
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {// если движение пальцем было прерванно внешними обстоятельствами как входящий звонок
        
    }
    override func update(_ currentTime: TimeInterval) { //обработка каждого кадра, т.е. при каждом новом кадре запускается этот метод, каждый определенный системой интервал времени
        snake?.move()
    }
    
    func putAppleAtRandomPlace(){ // рандомно размещаем яблоки на сцене
        let randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - 5)) + 1)
        let randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - 5)) + 1)
        
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        self.addChild(apple)
        
        
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let bodies = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask   // побитово складываем обе битвые маски, но мы изначально не знаем какие именно объекты столкнулись
        let collisionObj  = bodies ^ CollisionCategories.SnakeHead  //т.к. соприкосновение всегда будет происходить с головой, мы можем ее вычесть из суммы "тел")) и уже применить нужный метод
        switch collisionObj {
        case CollisionCategories.Apple:  //столкнулись с яблоком
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
            snake?.addBodyPart()
            apple?.removeFromParent()
            putAppleAtRandomPlace()
        case CollisionCategories.ScreenBody: //столкнулись с границами экрана
            snake?.removeTail()
            snake?.removeFromParent()
            snake = Snake(atPoint: CGPoint(x: view!.scene!.frame.midX, y: view!.scene!.frame.midY))
            addChild(snake!)
            
        case CollisionCategories.Snake: //столкнулись с границами экрана
            break
        default:
            break
        }
    }
}
