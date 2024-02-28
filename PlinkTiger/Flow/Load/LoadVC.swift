//
//  LoadVC.swift
//  PlinkTiger

import Foundation
import UIKit

class LoadingVC: UIViewController {
    
    
    private var contentView: LoadingView {
        view as? LoadingView ?? LoadingView()
    }
    
    override func loadView() {
        view = LoadingView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateProgressBar()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                  self.loadHomeVC()
              }
    }
    
    func animateProgressBar() {
        UIView.animate(withDuration: 3.5) {
            self.contentView.loadView.setProgress(1.0, animated: true)
        }
    }
    
    func loadHomeVC() {
        let vc = HomeVC()
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

