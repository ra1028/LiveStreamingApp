//
//  IPAddressTextField.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 3/9/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import UIKit

final class IPAddressTextField: UITextField {
    @IBInspectable var inset: CGFloat = 15
    
    convenience init() {
        self.init(frame: .init(x: 0, y: 0, width: 0, height: 50))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

private extension IPAddressTextField {
    func configure() {
        placeholder = "IP Adress"
        font = .systemFont(ofSize: 12)
        textColor = .black
        backgroundColor = UIColor(white: 1, alpha: 0.8)
        clearButtonMode = .always
        keyboardAppearance = .dark
        returnKeyType = .join
    }
}
