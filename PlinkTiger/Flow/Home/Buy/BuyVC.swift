//
//  BuyVC.swift
//  PlinkTiger
import Foundation
import UIKit

class BuyVC: UIViewController {

    
    private var contentView: BuyView {
        view as? BuyView ?? BuyView()
    }
    
    override func loadView() {
        view = BuyView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tappedButtons()
    }
    
    private func tappedButtons() {
        contentView.backBtn.addTarget(self, action: #selector(buttonTappedBack), for: .touchUpInside)
        contentView.buyBtn.addTarget(self, action: #selector(buttonTappedBuyMeat), for: .touchUpInside)
    }

    @objc func buttonTappedBack() {
        navigationController?.popViewController(animated: true)
    }
    @objc func buttonTappedBuyMeat() {
        if Memory.shared.scoreCoints >= 100 {
               Memory.shared.scoreCoints -= 100
               Memory.shared.scoreMeat += 1
               contentView.scoreCoints.text = "\(Memory.shared.scoreCoints)"
               contentView.scoreMeat.text = "\(Memory.shared.scoreMeat)"
            let congraAlert = UIAlertController(title: "Congratilations", message: "You have added one meat", preferredStyle: .alert)
            congraAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(congraAlert, animated: true, completion: nil)

           } else {
               let alert = UIAlertController(title: "Sorry", message: "You don't have enough points", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
               present(alert, animated: true, completion: nil)
           }
    }

}

