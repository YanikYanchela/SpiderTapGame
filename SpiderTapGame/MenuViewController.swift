//
//  ViewController.swift
//  SpiderTapGame
//
//  Created by Дмитрий Яновский on 1.04.24.
//

import UIKit

class MenuViewController: UIViewController {
    
    let nameLabel = UILabel()
    var backgroundImageView = UIImageView()
    let menuSpider = UIImageView()
    let scoreTableView = UIView()
    let recordLabel = UILabel()
    let lastScore = UILabel()
    let startButton = UIButton()
    // проверка на выгрузку из памяти ViewControllera
    var menuViewOpenCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImage()
        setupMenuSpider()
        setupNameLabel()
        setupScoreTableView()
        setupButton()
        scoreView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        menuViewOpenCount += 1
        startSpiderAnimation()
        print("menuViewController открыт \(menuViewOpenCount) раза")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("закрыт menuViewController")
    }
    func scoreView() {
        
        DispatchQueue.main.async {
            // Обновление интерфейса в основном потоке после завершения фоновой операции
            
            let currentRecord = UserDefaults.standard.integer(forKey: "RecordScore")
            self.recordLabel.text = "Record: \(currentRecord)"
            if let lastGameScore = UserDefaults.standard.value(forKey: "LastGameScore") as? Int {
                self.lastScore.text = "Last Game: \(lastGameScore) "
            } else {
                self.lastScore.text = "Last Game: "
            }
        }
    }
    // MARK: UI setup
    func setupNameLabel() {
        nameLabel.text = "Spider Tap"
        nameLabel.font =  UIFont(name: "SpiderNest", size: 85)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func setupBackgroundImage() {
        backgroundImageView = UIImageView(image: UIImage(named: "menuSpider"))
        backgroundImageView.frame = view.bounds
        backgroundImageView.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImageView, at: 0)
    }
    
    func setupScoreTableView() {
        scoreTableView.backgroundColor = .white
        scoreTableView.layer.shadowColor = UIColor.black.cgColor
        scoreTableView.layer.shadowOpacity = 1
        scoreTableView.layer.shadowOffset = CGSize(width: 3, height: 3)
        scoreTableView.layer.borderWidth = 2
        scoreTableView.layer.cornerRadius = 20
        scoreTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreTableView)
        
        MenuViewController.styleLabel(recordLabel, fontSize: 30)
        recordLabel.text = "Record"
        scoreTableView.addSubview(recordLabel)
        
        MenuViewController.styleLabel(lastScore, fontSize: 30)
        recordLabel.text = "Last game"
        scoreTableView.addSubview(lastScore)
        
        NSLayoutConstraint.activate([
            scoreTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -300),
            scoreTableView.widthAnchor.constraint(equalToConstant: 350),
            scoreTableView.heightAnchor.constraint(equalToConstant: 200),
            
            recordLabel.topAnchor.constraint(equalTo: scoreTableView.topAnchor, constant: 40),
            recordLabel.centerXAnchor.constraint(equalTo: scoreTableView.centerXAnchor),
            recordLabel.widthAnchor.constraint(equalToConstant: 250),
            recordLabel.heightAnchor.constraint(equalToConstant: 50),
            
            lastScore.topAnchor.constraint(equalTo: recordLabel.topAnchor, constant: 80),
            lastScore.centerXAnchor.constraint(equalTo: scoreTableView.centerXAnchor),
            lastScore.widthAnchor.constraint(equalToConstant: 350),
            lastScore.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    func setupMenuSpider() {
        menuSpider.frame = CGRect(x: 12.5, y: 120, width: 150, height: 150)
        menuSpider.image = UIImage(named: "menuAnimationSpider")
        view.insertSubview(menuSpider, at: 1)
    }
    
    func setupButton() {
        MenuViewController.styleButton(startButton, setTitle: "Let's Go", fontSize: 30, backgroundColor: .orange)
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func startGame() {
        
        let gameViewController = GameViewController()
        gameViewController.modalPresentationStyle = .fullScreen
        present(gameViewController, animated: true)
        
    }

    func startSpiderAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.menuSpider.transform = CGAffineTransform(translationX: 0, y: 20) // Устанавливаем смещение вверх
        })
    }
    
    
}





