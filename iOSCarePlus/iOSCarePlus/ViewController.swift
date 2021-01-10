//
//  ViewController.swift
//  iOSCarePlus
//
//  Created by 최원석 on 2020/12/04.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var logoView: UIView!
    @IBOutlet private weak var logoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundImageViewLeadingConstraint: NSLayoutConstraint!
    
    @IBAction private func logoTabAction(_ sender: UITapGestureRecognizer) {
        self.blinkLogoAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoView.layer.cornerRadius = 15
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationSettingDefault()
        appearLogoViewAnimation() { [weak self] in
            self?.slideBackgroundImageAnimation()
        }
    }
    private func animationSettingDefault() {
        logoViewTopConstraint.constant = -200
        backgroundImageViewLeadingConstraint.constant = 0
        logoView.alpha = 1
        view.layoutIfNeeded()
    }
    private func appearLogoViewAnimation(completion:@escaping () -> Void) {
        UIView.animate(withDuration: 0.7, delay: 1, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: []) { [weak self] in
            self?.logoViewTopConstraint.constant = 17
            self?.view.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
    private func slideBackgroundImageAnimation() {
        UIView.animate(withDuration: 5, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse]) { [weak self] in
            self?.backgroundImageViewLeadingConstraint.constant = -800
            self?.view.layoutIfNeeded()
        }
    }
    private func blinkLogoAnimation() {
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.autoreverse]) { [weak self] in
            self?.logoView.alpha = 0
        }
    }
}
