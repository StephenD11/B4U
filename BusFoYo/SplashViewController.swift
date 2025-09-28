//
//  SplashViewController.swift
//  BusFoYo
//
//  Created by Stepan on 27.09.2025.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    lazy var animationView: LottieAnimationView = {
        let animView = LottieAnimationView(name: "splash_anim")
        animView.translatesAutoresizingMaskIntoConstraints = false
        animView.contentMode = .scaleAspectFit
        animView.loopMode = .playOnce
        return animView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAnimationUI()
        playAnimation()
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
        if let user = UserManager.shared.currentUser {
            // Пользователь уже есть → переходим на экран ввода PIN-кода
            let pinVC = PinCodeViewController()
            self.navigationController?.setViewControllers([pinVC], animated: true)
        } else {
            // Пользователя нет → переходим на экран ввода логина и названия компании
            let authVC = AuthViewController()
            self.navigationController?.setViewControllers([authVC], animated: true)
        }
    }
}
