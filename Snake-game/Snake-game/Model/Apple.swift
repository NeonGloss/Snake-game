import SpriteKit
import UIKit

class Apple: SKShapeNode {
    convenience init(position: CGPoint){
        self.init()
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 10)).cgPath
        fillColor = UIColor.green
        lineWidth = 0
        self.position = position
        
        physicsBody = SKPhysicsBody(circleOfRadius: 10, center: CGPoint(x: 5, y: 5))
        
        //указываем кто мы есть
        physicsBody?.categoryBitMask = CollisionCategories.Apple
        //не указываем с чем следует обрабатывать соприкосновения, т.к. яблоко никуда не двигается
    }
}
