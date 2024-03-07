//
//  Double+Extensions.swift


import UIKit

extension Double {
    var autoSize: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let statusBarOrientation = windowScene.interfaceOrientation
            let screenSize = UIScreen.main.bounds.size
            let referenceSize: CGFloat = 395
            let screenSizeOrientation = statusBarOrientation.isPortrait ? screenSize.width : screenSize.height
            let maxAspectRatio = screenSizeOrientation / referenceSize
            
            return self * maxAspectRatio
        }
        return self
    }

    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded() / divisor
    }
    
    func formatNumber(_ number: Double) -> String {
        let formattedNumber = String(format: "%.0f", number)
        return formattedNumber
    }
}
