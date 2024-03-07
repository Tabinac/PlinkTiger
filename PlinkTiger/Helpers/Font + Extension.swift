//
//  Font + Extension.swift
//  PlinkTiger

import Foundation
import UIKit

extension UIFont {
    
    enum CustomFonts: String {
        case montserrat = "Montserrat"
        case lato = "Lato"
    }
    
    enum CustomFontStyle: String {
        case black = "-Black"
        case light = "-Light"
        case bold = "-Bold"
        case medium = "-Medium"
        case regular = "-Regular"
    }
    
    static func customFont(
        font: CustomFonts,
        style: CustomFontStyle,
        size: Int,
        isScaled: Bool = true) -> UIFont {
            
            let fontName: String = font.rawValue + style.rawValue
            
            guard let font = UIFont(name: fontName, size: CGFloat(size)) else {
                debugPrint("Font can't be loaded")
                return UIFont.systemFont(ofSize: CGFloat(size))
            }
            
            return isScaled ? UIFontMetrics.default.scaledFont(for: font) : font
        }
}

extension UIViewController {
     func updateScore() {
        let payload = UpdatePayload(name: nil, score: Memory.shared.scoreCoints)
        PostRequestService.shared.updateData(id: Memory.shared.userID!, payload: payload) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("Success")
                case .failure(let failure):
                    print("Error - \(failure.localizedDescription)")
                }
            }
        }
    }
    func updateName() {
        if Memory.shared.userName != nil {
            let payload = UpdatePayload(name: Memory.shared.userName, score: nil)
            PostRequestService.shared.updateData(id: Memory.shared.userID!, payload: payload) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("Success")
                    case .failure(let failure):
                        print("Error - \(failure.localizedDescription)")
                    }
                }
            }
        }
    }
}
