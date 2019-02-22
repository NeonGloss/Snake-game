struct CollisionCategories { //устанавливаем категории битовых масок к нашим объектам, т.е. определяем тип каждому из элементов как различные константы
    static let Snake: UInt32 = 0x1 << 0
    static let SnakeHead: UInt32 = 0x1 << 1
    static let Apple: UInt32 = 0x1 << 2
    static let ScreenBody: UInt32 = 0x1 << 3
}
