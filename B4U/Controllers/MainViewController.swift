//
//  MainViewController.swift
//  BusFoYo
//
//  Created by Stepan on 28.09.2025.
//
import UIKit
import Lottie

class MainViewController: UIViewController {
    
    var calculationsVC: CalculationsViewController = CalculationsViewController()
    let backgroundImageView = UIImageView(image: UIImage(named: "Back_Lines"))

    lazy var userNameTop: UILabel = {
        let lb = UILabel()
        lb.text = "Hi: \(UserManager.shared.currentUser?.username ?? "") 👋 "
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        lb.textColor = .black
        lb.textAlignment = .left
        return lb
    }()
  

    
    lazy var mainLabel: UILabel = {
       let lab = UILabel()
        lab.text = "Your company name: \(UserManager.shared.currentUser?.company ?? "")"
        lab.textColor = .lightGray
        lab.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lab.textAlignment = .left
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    lazy var bottomStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileButton, ordersButton, calculationsButton] )
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var centerImageView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "Main_Base")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()
        return animationView
    }()
    
    func createBottomButton(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        let normalColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.lightGray : UIColor.darkGray
        }
        btn.setTitleColor(normalColor, for: .normal)
        btn.setTitleColor(.orange, for: .highlighted)
        btn.tintColor = .clear
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
    
    lazy var profileNextButton = {
        let btn = UIButton()
        btn.setTitle("", for: . normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var profileButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "person.crop.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 17, weight: .medium))
        config.imagePlacement = .top
        config.imagePadding = 5
        config.baseForegroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .lightGray : .darkGray
        }

        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        return btn
    }()

    lazy var ordersButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "doc.text")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 17, weight: .medium))
        config.imagePlacement = .top
        config.imagePadding = 5
        config.baseForegroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .lightGray : .darkGray
        }

        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(ordersTapped), for: .touchUpInside)
        return btn
    }()

    lazy var calculationsButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "dollarsign.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 17, weight: .medium))
        config.imagePlacement = .top
        config.imagePadding = 5
        config.baseForegroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .lightGray : .darkGray
        }

        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(calculationsTapped), for: .touchUpInside)
        return btn
    }()
    
 
    
    let images = ["profileImage", "ordersImage", "calculationsImage"]
    var selectedButton: UIButton?
    var isAnimating = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTop.text = "Hi, \(UserManager.shared.currentUser?.username ?? "") 👋 "
        mainLabel.text = "Company: \(UserManager.shared.currentUser?.company ?? "")"
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        

        
        setupUI()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        centerImageView.isUserInteractionEnabled = true
        
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
    
    func setupUI() {
        
        view.addSubview(userNameTop)
        view.addSubview(mainLabel)
        view.addSubview(profileNextButton)
        view.addSubview(bottomStack)
        view.addSubview(centerImageView)
        view.sendSubviewToBack(centerImageView)

        
        NSLayoutConstraint.activate ([
            
            userNameTop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userNameTop.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            mainLabel.topAnchor.constraint(equalTo: userNameTop.bottomAnchor, constant: 5),
            mainLabel.leadingAnchor.constraint(equalTo: userNameTop.leadingAnchor),
                    
            bottomStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            bottomStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            bottomStack.heightAnchor.constraint(equalToConstant: 50),
            

            centerImageView.topAnchor.constraint(equalTo: view.topAnchor),
            centerImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            centerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            centerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)

        
            
        ])
    }
    
    @objc func profileTapped() {
        let buttons = [profileButton, ordersButton, calculationsButton]
        let currentIndex = buttons.firstIndex(of: selectedButton ?? profileButton) ?? 0
        let targetIndex = 0
        let swipeDirection: UISwipeGestureRecognizer.Direction = targetIndex > currentIndex ? .left : .right
        changeCenterImage(to: images[0], selected: profileButton, swipeDirection: swipeDirection)
    }
    
    @objc func ordersTapped() {
        let buttons = [profileButton, ordersButton, calculationsButton]
        let currentIndex = buttons.firstIndex(of: selectedButton ?? profileButton) ?? 0
        let targetIndex = 1
        let swipeDirection: UISwipeGestureRecognizer.Direction = targetIndex > currentIndex ? .left : .right
        changeCenterImage(to: images[1], selected: ordersButton, swipeDirection: swipeDirection)
    }
    
    @objc func calculationsTapped() {
        let buttons = [profileButton, ordersButton, calculationsButton]
        let currentIndex = buttons.firstIndex(of: selectedButton ?? profileButton) ?? 0
        let targetIndex = 2
        let swipeDirection: UISwipeGestureRecognizer.Direction = targetIndex > currentIndex ? .left : .right
        changeCenterImage(to: images[2], selected: calculationsButton, swipeDirection: swipeDirection)
    }
    
    
    
    
    func changeCenterImage(to imageName: String, selected button: UIButton, swipeDirection: UISwipeGestureRecognizer.Direction) {
        guard selectedButton !== button else { return }
        guard !isAnimating else { return }
        isAnimating = true

        let buttons = [self.profileButton, self.ordersButton, self.calculationsButton]

        for btn in buttons {
            btn.configuration?.baseForegroundColor = (btn == button) ? .systemYellow : UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? .lightGray : .darkGray
            }
        }

        self.selectedButton = button

        let oldImageView = self.centerImageView
        let oldButton = view.viewWithTag(999)

        // Создаём новый LottieAnimationView вместо UIImageView
        let animationName: String
        switch imageName {
        case "profileImage":
            animationName = "Talent Search"
        case "ordersImage":
            animationName = "Package Box Animation"
        case "calculationsImage":
            animationName = "Cash or Card"
        default:
            animationName = "Main_Base"
        }
        let newAnimationView = LottieAnimationView(name: animationName)
        newAnimationView.translatesAutoresizingMaskIntoConstraints = false
        newAnimationView.contentMode = .scaleAspectFit
        newAnimationView.loopMode = .loop
        newAnimationView.backgroundBehavior = .continuePlaying

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            newAnimationView.play()
        }
        view.addSubview(newAnimationView)

        NSLayoutConstraint.activate([
            newAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            newAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            newAnimationView.heightAnchor.constraint(equalTo: newAnimationView.widthAnchor),
        ])

        let buttonTitle: String
        switch imageName {
        case "profileImage":
            buttonTitle = "ENTER TO PROFILE"
        case "ordersImage":
            buttonTitle = "SEE YOUR ORDERS"
        case "calculationsImage":
            buttonTitle = "CHECK YOUR CASH"
        default:
            buttonTitle = "ACTION"
        }

        let imageActionButton = UIButton(type: .custom)
        imageActionButton.tag = 999
        imageActionButton.setTitle(buttonTitle, for: .normal)
        imageActionButton.setTitleColor(.white, for: .normal)
        switch imageName {
        case "profileImage":
            imageActionButton.setImage(UIImage(named: "Button Your Profile light"), for: .normal)
            imageActionButton.setImage(UIImage(named: "Button Your Profile dark"), for: .highlighted)
        case "ordersImage":
            imageActionButton.setImage(UIImage(named: "Button Your orders light"), for: .normal)
            imageActionButton.setImage(UIImage(named: "Button Your orders dark"), for: .highlighted)
        case "calculationsImage":
            imageActionButton.setImage(UIImage(named: "Button Your cash light"), for: .normal)
            imageActionButton.setImage(UIImage(named: "Button Your cash dark"), for: .highlighted)
        default:
            break
        }
        imageActionButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        imageActionButton.backgroundColor = UIColor(red: 1.0, green: 0.55, blue: 0.0, alpha: 1.0)
        imageActionButton.layer.cornerRadius = 6
        imageActionButton.translatesAutoresizingMaskIntoConstraints = false
        imageActionButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        imageActionButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        imageActionButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchDragExit])

        view.addSubview(imageActionButton)
        NSLayoutConstraint.activate([
            imageActionButton.topAnchor.constraint(equalTo: newAnimationView.bottomAnchor, constant: -10),
            imageActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageActionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            imageActionButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        let translationX = swipeDirection == .left ? view.frame.width : -view.frame.width

        newAnimationView.transform = CGAffineTransform(translationX: translationX, y: 0)
        imageActionButton.transform = CGAffineTransform(translationX: translationX, y: 0)

        view.layoutIfNeeded()

        UIView.animate(withDuration: 0.4, animations: {
            oldImageView.transform = CGAffineTransform(translationX: -translationX, y: 0)
            oldButton?.transform = CGAffineTransform(translationX: -translationX, y: 0)
            newAnimationView.transform = .identity
            imageActionButton.transform = .identity
        }, completion: { _ in
            oldImageView.removeFromSuperview()
            oldButton?.removeFromSuperview()
            self.centerImageView = newAnimationView
            self.isAnimating = false
        })

        UIView.animate(withDuration: 0.3) {
            for btn in [self.profileButton, self.ordersButton, self.calculationsButton] {
                if btn != button {
                    btn.transform = .identity
                }
            }
            button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    
    @objc func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.view.viewWithTag(999)?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    @objc func buttonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.view.viewWithTag(999)?.transform = .identity
        }
    }

    @objc func imageButtonTapped(_ sender: UIButton) {
        if sender.title(for: .normal) == "ENTER TO PROFILE" {
            let profileVC = ProfileViewController()
            navigationController?.pushViewController(profileVC, animated: true)
        }
        
        if sender.title(for: .normal) == "SEE YOUR ORDERS" {
            let ordersVC = OrdersViewController()
            ordersVC.calculationsVC = self.calculationsVC
            navigationController?.pushViewController(ordersVC, animated: true)
        }
        
        if sender.title(for: .normal) == "CHECK YOUR CASH" {
                navigationController?.pushViewController(calculationsVC, animated: true)
            }
        
        
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard !isAnimating else { return }

        let buttons = [profileButton, ordersButton, calculationsButton]
        guard let currentButton = selectedButton,
              let currentIndex = buttons.firstIndex(of: currentButton) else { return }

        var nextIndex: Int
        if gesture.direction == .left {
            nextIndex = min(currentIndex + 1, buttons.count - 1)
        } else {
            nextIndex = max(currentIndex - 1, 0)
        }

        let nextButton = buttons[nextIndex]
        let nextImageName: String
        switch nextButton {
        case profileButton:
            nextImageName = "profileImage"
        case ordersButton:
            nextImageName = "ordersImage"
        case calculationsButton:
            nextImageName = "calculationsImage"
        default:
            return
        }

        changeCenterImage(to: nextImageName, selected: nextButton, swipeDirection: gesture.direction)
    }
    
}
