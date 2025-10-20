//
//  SplashViewController.swift
//  BusFoYo
//
//  Created by Stepan on 27.09.2025.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    let backgroundImageView = UIImageView(image: UIImage(named: "Background_anim"))

    
    lazy var animationView: LottieAnimationView = {
        let animView = LottieAnimationView(name: "splash_anim")
        animView.translatesAutoresizingMaskIntoConstraints = false
        animView.contentMode = .scaleAspectFit
        animView.loopMode = .playOnce
        return animView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupAnimationUI()
        playAnimation()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(skipAnimation))
        view.addGestureRecognizer(tap)
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }

    func setupAnimationUI() {
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    func playAnimation() {
        animationView.play { [weak self] finished in
            self?.goToNextScreen()
        }
    }

    func goToNextScreen() {
        let nextVC: UIViewController
        if let _ = UserManager.shared.currentUser {
            nextVC = PinCodeViewController()
        } else {
            nextVC = AuthViewController()
        }

        guard let window = view.window else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = UINavigationController(rootViewController: nextVC)
        }, completion: nil)
    }
    
    @objc func skipAnimation() {
        animationView.stop()
        goToNextScreen()
    
    }
    
}
