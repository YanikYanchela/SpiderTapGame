//
//  ButtonAndLabelStyler.swift
//  SpiderTapGame
//
//  Created by Дмитрий Яновский on 6.04.24.
//

import UIKit

extension UIViewController {
    
    static func styleLabel (_ label: UILabel, fontSize: CGFloat) {
        label.font =  UIFont(name: "Agitpropc", size: fontSize)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    static func styleButton(_ button: UIButton, setTitle: String, fontSize: CGFloat, backgroundColor: UIColor) {
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle(setTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: "Agitpropc", size: fontSize)
        button.layer.borderWidth = 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.cornerRadius = 10
        button.backgroundColor = backgroundColor

        
        button.addTarget(self, action: #selector(buttonTouchUpInside(_:event:)), for: .touchUpInside)
    }
    
    @objc private static func buttonTouchUpInside(_ sender: UIButton, event: UIEvent) {
        UIView.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { finished in
            UIView.animate(withDuration: 0.2) {
                sender.transform = .identity
            }
        }
    }
}

