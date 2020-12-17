//
//  UIProtocol.swift
//  SpeakIPA
//
//  Created by nguyen thy on 11/3/20.
//

import Foundation
import UIKit

protocol standardButtonDelegate: class {
    func updateButton(_ button: UIButton)
}

class standardButtonClass: UIViewController, standardButtonDelegate {
    func updateButton(_ button: UIButton) {
        button.layer.cornerRadius = 0.5
    }
}

extension UIButton {
    func becomeStandard() {
        self.layer.cornerRadius = 20
        
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 65)
        self.addConstraint(heightConstraint)
        
        self.titleLabel?.font = UIFont(name: "Times New Roman", size: 23)
    }
}
