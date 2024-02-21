//
//  CustomSKSpriteNode.swift

import SpriteKit

class RoundedCornerSpriteNode: SKSpriteNode {

    convenience init(color: UIColor, size: CGSize, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        let texture = RoundedCornerSpriteNode.texture(color: color, size: size, cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor)
        self.init(texture: texture, color: .clear, size: size)
    }

    private class func texture(color: UIColor, size: CGSize, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) -> SKTexture {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!

        let rect = CGRect(origin: .zero, size: size)
        let roundedRectPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        // Fill with color
        context.setFillColor(color.cgColor)
        roundedRectPath.fill()
        
        // Draw border
        if borderWidth > 0 {
            context.setStrokeColor(borderColor.cgColor)
            context.setLineWidth(borderWidth)
            roundedRectPath.stroke()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return SKTexture(image: image)
    }
}

