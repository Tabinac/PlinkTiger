//
//  CircleView.swift
//  PlinkTiger

import Foundation
import UIKit
import SnapKit

class CircleView: UIView {
    
    private var startAngle: CGFloat
    private var endAngle: CGFloat
    private var color: UIColor
    private var segmentImage: UIImage?
    private var label: UILabel?
    private var segmentNumber: Int?
    
    init(startAngle: CGFloat, endAngle: CGFloat, color: UIColor) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.color = color
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(startAngle),
            y: center.y + radius * sin(startAngle)
        )
        
        context.move(to: center)
        context.addLine(to: start)
        context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        context.addLine(to: center)
        context.setFillColor(color.cgColor)
        context.fillPath()
        }
    }

