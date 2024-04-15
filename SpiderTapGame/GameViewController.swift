//
//  GameViewController.swift
//  SpiderTapGame
//
//  Created by Дмитрий Яновский on 1.04.24.
//

import UIKit

class GameViewController: UIViewController {
    
    var gameModel = ModelGame(score: 0, gameTime: 30, currentTime: 0)
    var timer: Timer?
    
    let scoreBarView = UIView()
    let scoreLabel = UILabel()
    let timeLabel = UILabel()
    
    let endGameButton = UIButton()
    
    let gameView = UIView()
    let spider = UIImageView(frame: CGRect(x: 150, y: 450, width: 100, height: 60))
    var backgroundGameImageView = UIImageView()
    // проверка на выгрузку из памяти ViewController
    var gameViewOpenCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScoreBarView()
        setupbackgroundGameImageView()
        setupGameView()
        setupendGameButton()
        setupScoreLabel()
        setupTimeLabel()
        setupSpider()
        startGameTimer()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameViewOpenCount += 1
        print("GameViewController открыт \(gameViewOpenCount) раза")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("закрыт GameViewController")
    }
    
    func setupbackgroundGameImageView() {
        backgroundGameImageView = UIImageView(image: UIImage(named: "menuSpider"))
        backgroundGameImageView.frame = view.bounds
        backgroundGameImageView.contentMode = .scaleAspectFill
        gameView.insertSubview(backgroundGameImageView, at: 0)
    }
    
    func setupScoreBarView() {
        scoreBarView.backgroundColor = .white
        scoreBarView.layer.cornerRadius = 20
        scoreBarView.layer.borderWidth = 2
        scoreBarView.layer.shadowOpacity = 1
        scoreBarView.layer.shadowOffset = CGSize(width: 2, height: 2)
        scoreBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreBarView)
        
        NSLayoutConstraint.activate([
            scoreBarView.topAnchor.constraint(equalTo: view.topAnchor),
            scoreBarView.heightAnchor.constraint(equalToConstant: 80),
            scoreBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scoreBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    func setupScoreLabel() {
        GameViewController.styleLabel(scoreLabel, fontSize: 45)
        scoreLabel.text = "\(gameModel.score)"
        scoreBarView.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.bottomAnchor.constraint(equalTo: scoreBarView.bottomAnchor, constant: -5),
            scoreLabel.leadingAnchor.constraint(equalTo: scoreBarView.leadingAnchor, constant: 20)
        ])
    }
    
    func setupTimeLabel() {
        GameViewController.styleLabel(timeLabel, fontSize: 45)
        timeLabel.text = "\(gameModel.gameTime)"
        scoreBarView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.bottomAnchor.constraint(equalTo: scoreBarView.bottomAnchor, constant: -5),
            timeLabel.trailingAnchor.constraint(equalTo: scoreBarView.trailingAnchor, constant: -20)
        ])
    }
    
    func setupendGameButton() {
        GameViewController.styleButton(endGameButton, setTitle: "end", fontSize: 17, backgroundColor: .red)
        endGameButton.addTarget(self, action: #selector(GameOverButton), for: .touchUpInside)
        endGameButton.translatesAutoresizingMaskIntoConstraints = false
        scoreBarView.addSubview(endGameButton)
        
        NSLayoutConstraint.activate([
            endGameButton.centerXAnchor.constraint(equalTo: scoreBarView.centerXAnchor),
            endGameButton.centerYAnchor.constraint(equalTo: scoreBarView.centerYAnchor, constant: 21),
            endGameButton.widthAnchor.constraint(equalToConstant: 50),
            endGameButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func setupGameView() {
        view.backgroundColor = .white
        gameView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameView)
        
        NSLayoutConstraint.activate([
            gameView.topAnchor.constraint(equalTo: scoreBarView.bottomAnchor, constant: 10),
            gameView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    func setupSpider() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        spider.image = UIImage(named: "spiderGame")
        gameView.addSubview(spider)
        spider.isUserInteractionEnabled = true
        spider.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageTap() {
        gameModel.incrementScore()
        scoreLabel.text = "\(gameModel.score)"
        print("tap \(gameModel.score)")
        
        let sizeViewBounds = self.gameView.bounds
        let newX = CGFloat.random(in: 0...(sizeViewBounds.width - self.spider.frame.width))
        let newY = CGFloat.random(in: 0...(sizeViewBounds.height - self.spider.frame.height))
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            UIView.animate(withDuration: 0.2) {
                self.spider.frame.origin = CGPoint(x: newX, y: newY)
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.spider.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: -0.5...1.5))
                }) { finished in
                    UIView.animate(withDuration: 0.2) {
                        self.spider.transform = .identity
                    }
                }
            }
        }
    }
    
    func startGameTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        gameModel.updateTime()
        let timeLeft = max(gameModel.gameTime - gameModel.currentTime, 0)
        DispatchQueue.main.async {
            self.timeLabel.text = "\(timeLeft)"
        }
        
        if timeLeft == 0 {
            endGame()
        }
    }
    
    func endGame() {
        timer?.invalidate()
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        view.addSubview(blurView)
        
        let currentRecord = UserDefaults.standard.integer(forKey: "RecordScore")
        
        if gameModel.score > currentRecord {
            UserDefaults.standard.set(gameModel.score, forKey: "RecordScore")
        }
        
        UserDefaults.standard.set(gameModel.score, forKey: "LastGameScore")
        
        let gameAlert = EndGameAlert(frame: CGRect(x: 0, y: 0, width: 300, height: 200), tapsCount: gameModel.score)
        gameAlert.center = view.center
        gameAlert.delegate = self
        view.addSubview(gameAlert)
    }
    
    @objc func GameOverButton() {
        endGame()
    }
}

extension GameViewController: EndGameAlertDelegate {
    func playAgainButtonTapped() {
        gameModel.reset()
        scoreLabel.text = "\(gameModel.score)"
        timeLabel.text = "\(gameModel.gameTime)"
        startGameTimer()
        
        for subview in view.subviews {
            if let alertView = subview as? EndGameAlert {
                alertView.removeFromSuperview()
            }
            if let blurView = subview as? UIVisualEffectView {
                blurView.removeFromSuperview()
            }
        }
    }
    
    func finishButtonTapped() {
        let menuViewController = MenuViewController()
        menuViewController.modalPresentationStyle = .fullScreen
        present(menuViewController, animated: true)
        
    }
}


