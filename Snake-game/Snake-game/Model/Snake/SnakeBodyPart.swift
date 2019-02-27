import UIKit
import SpriteKit

class SnakeBodyPart: SKShapeNode {
    let diameter = 10.0
    
    init(atPoint point: CGPoint){
        super.init()
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: CGFloat(diameter), height: CGFloat(diameter))).cgPath
        fillColor = UIColor.purple
        lineWidth = 0
        self.position = point
        
        physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(diameter - 4), center: CGPoint(x: 5, y: 5))
        physicsBody?.categoryBitMask = CollisionCategories.Snake
        physicsBody?.contactTestBitMask = CollisionCategories.ScreenBody | CollisionCategories.Apple //если будет соприкосновение со сторонами экрана - то мы проиграли, если с яблоком - наращиваем хвост
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
