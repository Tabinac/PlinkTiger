//
//  ChoseVC.swift
//  PlinkTiger
//
import Foundation
import UIKit

class ChoseVC: UIViewController {

    
    private var contentView: ChoseView {
        view as? ChoseView ?? ChoseView()
    }
    
    override func loadView() {
        view = ChoseView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tappedButtons()
    }
    
    private func tappedButtons() {
        contentView.backBtn.addTarget(self, action: #selector(buttonTappedBack), for: .touchUpInside)
        contentView.classicBtn.addTarget(self, action: #selector(buttonTappedPlay), for: .touchUpInside)
        contentView.catchBtn.addTarget(self, action: #selector(buttonTappedCatch), for: .touchUpInside)
        contentView.placeBtn.addTarget(self, action: #selector(buttonTappedPlace), for: .touchUpInside)
    }

    @objc func buttonTappedPlay() {
        let classicVC = ClassicVC()
        navigationController?.pushViewController(classicVC, animated: true)
    }

    @objc func buttonTappedCatch() {
        let catchVC = CatchBallVC()
        navigationController?.pushViewController(catchVC, animated: true)
    }
    
    @objc func buttonTappedPlace() {
        
        let placeVC = PlaceBallVC()
        navigationController?.pushViewController(placeVC, animated: true)
    }
    @objc func buttonTappedBack() {
        navigationController?.popViewController(animated: true)
    }
}

