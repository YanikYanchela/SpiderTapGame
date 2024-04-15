//
//  EndGameAlert.swift
//  SpiderTapGame
//
//  Created by Дмитрий Яновский on 1.04.24.
//

import UIKit


protocol EndGameAlertDelegate: AnyObject {
    func playAgainButtonTapped()
    func finishButtonTapped()
}

class EndGameAlert: UIView {
    
    weak var delegate: EndGameAlertDelegate?
    
    init(frame: CGRect, tapsCount: Int) {
        super.init(frame: frame)
        setupUI(tapsCount: tapsCount)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI(tapsCount: 0)
    }
    
    private func setupUI(tapsCount: Int) {
        // содание экзэмпляра UIViewController для использвания метода ButtonStyle
        _ = UIViewController()
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2, height: 2)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: frame.width, height: 30))
        configureLabel(titleLabel, text: "Game Over", fontSize: 40)
        addSubview(titleLabel)
        
        let tapsLabel = UILabel(frame: CGRect(x: 0, y: titleLabel.frame.maxY + 40, width: frame.width, height: 30))
        configureLabel(tapsLabel, text: "Count taps: \(tapsCount)", fontSize: 30)
        addSubview(tapsLabel)
        
        let buttonWidth = (frame.width - 60) / 2
        
        let playAgainButton = UIButton(frame: CGRect(x: 20, y: tapsLabel.frame.maxY + 20, width: buttonWidth, height: 40))
        UIViewController.styleButton(playAgainButton, setTitle: "Repeat", fontSize: 25, backgroundColor: .orange)
        playAgainButton.addTarget(self, action: #selector(playAgainButtonTapped), for: .touchUpInside)
        addSubview(playAgainButton)
        
        let finishButton = UIButton(frame: CGRect(x: playAgainButton.frame.maxX + 20, y: playAgainButton.frame.minY, width: buttonWidth, height: 40))
        UIViewController.styleButton(finishButton, setTitle: "End", fontSize: 25, backgroundColor: .red)
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        addSubview(finishButton)
    }
    
    private func configureLabel(_ label: UILabel, text: String, fontSize: CGFloat) {
        label.text = text
        label.font = UIFont(name: "Agitpropc", size: fontSize)
        label.textAlignment = .center
    }
    
    @objc private func playAgainButtonTapped() {
        delegate?.playAgainButtonTapped()
    }
    
    @objc private func finishButtonTapped() {
        delegate?.finishButtonTapped()
    }
}

