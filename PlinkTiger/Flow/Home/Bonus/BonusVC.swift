//
//  BonusVC.swift
//  PlinkTiger

import Foundation
import UIKit
import SnapKit


class BonusVC: UIViewController {
    
    private var isTime: Bool = true
    private var spin: CGFloat = 0
    private var meatCounts: Int = 0

    private var contentView: BonusView {
        view as? BonusView ?? BonusView()
    }
    
    override func loadView() {
        view = BonusView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tappedButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goDailyScreen()
    }
    
    private func tappedButtons() {
        contentView.bonusBtn.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
        contentView.homeButtonsDayli.addTarget(self, action: #selector(goButtonTappedHome), for: .touchUpInside)
        contentView.homeButtonsTimer.addTarget(self, action: #selector(goButtonTappedHome), for: .touchUpInside)
        contentView.okBtn.addTarget(self, action: #selector(goButtonTappedHome), for: .touchUpInside)
    }

    @objc func goButtonTappedHome() {
        navigationController?.popViewController(animated: true)
    }
        
    @objc func goButtonTapped() {
        spinCircle { [weak self] in
            self?.pushBonusPrizVC()
        }
    }
    
    private func pushBonusPrizVC() {
        let vc = CongratilationVC()
        vc.total = meatCounts
        navigationController?.pushViewController(vc, animated: true)
    }

    private func spinCircle(completion: (() -> Void)? = nil) {
        contentView.bonusBtn.isEnabled = false
        let sectorAngles: [CGFloat] = [22, 67, 112, 157, 202, 247, 292, 337]
        
        let randomSectorAngle = sectorAngles.randomElement() ?? 360
        
        let randomRotation = randomSectorAngle * .pi / 180.0         // угол в радианы
        
        switch randomSectorAngle {
        case 22:
            meatCounts = contentView.segmentValues[5]
        case 67:
            meatCounts = contentView.segmentValues[4]
        case 112:
            meatCounts = contentView.segmentValues[3]
        case 157:
            meatCounts = contentView.segmentValues[2]
        case 202:
            meatCounts = contentView.segmentValues[1]
        case 247:
            meatCounts = contentView.segmentValues[0]
        case 292:
            meatCounts = contentView.segmentValues[7]
        case 337:
            meatCounts = contentView.segmentValues[6]
        default:
            break
        }
        
        Memory.shared.scoreMeat += meatCounts
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = CGFloat.pi * 12 + randomRotation
        rotationAnimation.duration = 3.0
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.contentView.bonusBtn.isEnabled = true
            }
        }
        contentView.wheelContainer.layer.add(rotationAnimation, forKey: "rotationAnimation")
        CATransaction.commit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            
            completion?()
        }
    }
}

extension BonusVC {
    
    func goDailyScreen() {
        if let lastVisitDate = Memory.shared.lastBonusDate {
            let calendar = Calendar.current
            if let hours = calendar.dateComponents([.hour], from: lastVisitDate, to: Date()).hour, hours < 24 {
                isTime = true
                contentView.timerView.isHidden = false
                startCountdownTimer()
            } else {
                isTime = false
                contentView.timerView.isHidden = true
            }
        }
    }
    
    func startCountdownTimer() {
        let calendar = Calendar.current
        
        guard let lastVisitDate = Memory.shared.lastBonusDate,
              let targetDate = calendar.date(byAdding: .day, value: 1, to: lastVisitDate) else {
            return
        }
        
        let now = Date()
        if now < targetDate {
            let timeRemaining = calendar.dateComponents([.hour, .minute, .second], from: now, to: targetDate)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                guard let self = self else {
                    timer.invalidate()
                    return
                }
                
                let now = Date()
                if now >= targetDate {
                    UserDefaults.standard.set(now, forKey: "LastVisitDate")
                    self.dismiss(animated: true, completion: nil)
                    timer.invalidate()
                } else {
                    let timeRemaining = calendar.dateComponents([.hour, .minute, .second], from: now, to: targetDate)
                    let timeString = String(format: "%02d:%02d:%02d", timeRemaining.hour ?? 0, timeRemaining.minute ?? 0, timeRemaining.second ?? 0)
                    self.contentView.timecountLabel.text = "\(timeString)"
                }
            }
        } else {
            UserDefaults.standard.set(now, forKey: "LastVisitDate")
        }
    }
    
}

