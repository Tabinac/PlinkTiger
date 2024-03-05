//
//  InfoRullesVC.swift


import Foundation
import UIKit

final class InfoRullesVC: UIViewController {
    
    private var contentView: InfoRullesView {
        view as? InfoRullesView ?? InfoRullesView()
    }
    
    override func loadView() {
        view = InfoRullesView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tappedButtons()
    }
    
    
    private func tappedButtons() {
        contentView.backBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}

