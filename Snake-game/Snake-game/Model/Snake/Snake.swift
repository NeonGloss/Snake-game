import UIKit
import SpriteKit

class Snake: SKShapeNode {
    var body = [SnakeBodyPart]()
    let moveSpeed = 125.0
    var angle: CGFloat = 0.0
    
    convenience init(atPoint point: CGPoint){
        self.init()  //инициализация всех родительских свойств ????  почему не super.init() что за self такой?
        
        let head = SnakeHead(atPoint: point)
        body.append(head)
        addChild(head)   // отображает элемент(голову) внутри объекта
    }
    
    func addBodyPart(){
        let newBodyPart = SnakeBodyPart(atPoint: body[0].position)
        body.append(newBodyPart)
        addChild(newBodyPart)
    }
    func removeTail(){
        guard body.count > 1 else {
            return
        }
        for index in ((body.count - 1)...1) {
            body[index].removeFromParent()
            body.remove(at: index)
        }
    }
    
    func move(){
        guard !body.isEmpty else {
            return
        }
        let head = body[0]
        moveHead(head)
        for index in (0..<body.count) where index > 0 {
            let previousPart = body[index - 1]
            let current = body[index]
            moveBodyPart(targetPlaceAt: previousPart, currentBodyPart: current)
        }
    }
    
    func moveClockwise(){
        angle += CGFloat(Double.pi / 2)
    }
    func moveCounterClockwise(){
        angle -= CGFloat(Double.pi / 2)
    }
    
    func moveHead(_ head: SnakeBodyPart){
        let dx = CGFloat(moveSpeed) * sin(angle)  //благодаря синусу мы узнаем координату Х
        let dy = CGFloat(moveSpeed) * cos(angle)  //благодаря синусу мы узнаем координату Y
        let nextPosition = CGPoint(x: dx + head.position.x, y: dy + head.position.y)
        
        let moveAnimation = SKAction.move(to: nextPosition, duration: 1.0)
        head.run(moveAnimation)
    }
    
    func moveBodyPart(targetPlaceAt targetPart: SnakeBodyPart,currentBodyPart currentPart: SnakeBodyPart){
        
        let moveAnimation = SKAction.move(to: CGPoint(x: targetPart.position.x, y: targetPart.position.y), duration: 0.05)
        currentPart.run(moveAnimation)
    }
}
