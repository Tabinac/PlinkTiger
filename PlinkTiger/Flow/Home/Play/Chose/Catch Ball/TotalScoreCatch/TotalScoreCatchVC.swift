//
//  TotalScoreCatchVC.swift



import Foundation
import UIKit
import SnapKit

class TotalScoreCatchVC: UIViewController {
    
    var total: Int = 0
    
    var contentView: TotalScoreCatchView {
        view as? TotalScoreCatchView ?? TotalScoreCatchView()
    }
    
    override func loadView() {
        view = TotalScoreCatchView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tappedButtons()
        configureLabel()
    }
    
    private func tappedButtons() {
        contentView.backBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        contentView.thanksBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }
    
    private func configureLabel() {
        contentView.scoreCointsLabel.text = "+\(total)"
    }

    @objc func closeView() {
        navigationController?.popViewController(animated: true)
    }
}
