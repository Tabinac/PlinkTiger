//
//  CusomButton.swift

import SpriteKit

class CustomSKButton: SKSpriteNode {
    var action: (() -> Void)?
    var active: Bool = true
    var disable: UIImage?
    
    var normal: UIImage? {
        didSet{
            guard let img = normal else { return }
            self.texture = SKTexture(image: img)
        }
    }
    
    init(texture: SKTexture) {
        super.init(texture: texture, color: .clear, size: texture.size())
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 0.5
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 1.0
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if contains(touchLocation) {
            action?()
        }
    }
    
    override func contains(_ point: CGPoint) -> Bool {
        let halfWidth = size.width
        let halfHeight = size.height
        
        return abs(point.x) < halfWidth && abs(point.y) < halfHeight
    }
    
     func setActive(active: Bool) {
        self.active = active
        if active {
            isUserInteractionEnabled = true
            guard let img = normal else { return }
            self.texture = SKTexture(image: img)
        } else {
            isUserInteractionEnabled = false
            guard let img = disable else { return }
            texture = SKTexture(image: img)
        }
    }
}
