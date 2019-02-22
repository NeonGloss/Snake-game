import UIKit

class SnakeHead: SnakeBodyPart {
    override init(atPoint point: CGPoint) {
        super.init(atPoint: point)
        
        //само physicsBody наследуется от родительского класса
        physicsBody?.categoryBitMask = CollisionCategories.SnakeHead
        physicsBody?.contactTestBitMask = CollisionCategories.ScreenBody | CollisionCategories.Apple | CollisionCategories.Snake //если будет соприкосновение со сторонами экрана - то мы проиграли, если с яблоком - наращиваем хвост
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
