//
//  TextSphere.swift
//  HoverTextFieldView
//
//  Created by cagricolak on 18.06.2019.
//  Copyright © 2019 cagricolak. All rights reserved.
//

import UIKit
import AudioToolbox

public class TextSphere: UIView {
    
    public var characterLimit = 10
    private let bottomBorder = CALayer()
    private let borderHeight = CGFloat(1.0)
    
    public var placeholderText = "TextSphere Placeholder"{
        willSet {
            placeholderLabel.text = newValue
        }
    }
    
    public var upperText = "TextSphere Placeholder" {
        willSet {
            overHolderLabel.text = newValue
        }
    }
    
    public var upperTextColor = UIColor.darkGray {
        willSet {
            overHolderLabel.textColor = newValue
        }
    }
    
    public var placeholderColor = UIColor.lightGray {
        willSet {
            placeholderLabel.textColor = newValue
        }
    }
    
    public var textColor = UIColor.darkGray {
        willSet {
            textView.textColor = newValue
        }
    }
    
    public  var borderColor = UIColor.clear.cgColor {
        willSet {
            textView.layer.borderColor = newValue
        }
    }
    
    public  var borderWidth = CGFloat.init() {
        willSet {
            textView.layer.borderWidth = newValue
        }
    }
    
    public var textFont = UIFont.systemFont(ofSize: 17) {
        willSet {
            textView.font = newValue
        }
    }
    
    public var placeholderTextFont = UIFont.systemFont(ofSize: 16) {
        willSet {
            placeholderLabel.font = newValue
        }
    }
    
    public var upperTextFont = UIFont.systemFont(ofSize: 16) {
        willSet {
            overHolderLabel.font = newValue
        }
    }
    
    private var savedTextCount: Int = 0
    
    private enum AnimateStyle {
        case show, hide
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init() {
        self.init()
    }
    
    let sphere = UITextView(frame: CGRect.zero)

    private lazy var textView: UITextView = {
        sphere.delegate = self
        sphere.font = textFont
        sphere.textColor = textColor
        sphere.layer.borderColor = borderColor
        sphere.layer.borderWidth = borderWidth
        sphere.layer.cornerRadius = 5
        sphere.isScrollEnabled = true
        sphere.backgroundColor = .clear
        sphere.restorationIdentifier = "TextSphere"
        addSubview(sphere)
        
        return sphere
    }()
    
    
    private lazy var placeholderLabel: UILabel = {
        let pLabel = UILabel(frame: .zero)
        pLabel.text = placeholderText
        pLabel.font = placeholderTextFont
        pLabel.textColor = placeholderColor
        addSubview(pLabel)
        return pLabel
    }()
    
    private lazy var overHolderLabel: UILabel = {
        let pLabel = UILabel(frame: .zero)
        pLabel.text = upperText
        pLabel.font = upperTextFont
        pLabel.textColor = upperTextColor
        pLabel.alpha = 0
        addSubview(pLabel)
        return pLabel
    }()
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        self.clipsToBounds = true
        sphere.isScrollEnabled = true
        self.layer.masksToBounds = false
        for ts in (superview?.subviews)! {
            for sphere in ts.subviews {
                if sphere.restorationIdentifier == "TextSphere" {
                    textView.heightAnchor.constraint(equalToConstant: ts.frame.height).isActive = true
                }
            }
        }
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        
        
    }
    
    private func setup(){
        backgroundColor = nil
        
        overHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        overHolderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        overHolderLabel.topAnchor.constraint(equalTo: topAnchor, constant: -20).isActive = true
        overHolderLabel.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        
        
    }
}

extension TextSphere: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count == 0 {
            animateTitle(.hide)
            
        } else if textView.text.count == 1 && textView.text.count > savedTextCount {
            animateTitle(.show)
        }
        
        savedTextCount = textView.text.count
        placeholderLabel.isHidden = textView.text.count > 0
        
    }
    
    private func adjustTextViewHeight() {
        if textView.frame.size.height == 0 {
            textView.heightAnchor.constraint(equalToConstant: 40)
        }else {
            let fixedWidth = textView.frame.size.width
            let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            
            bottomBorder.borderColor = UIColor.black.cgColor
            bottomBorder.frame = CGRect(x: 0, y: newSize.height, width:  self.frame.size.width, height: borderHeight)
            bottomBorder.borderWidth = self.layer.frame.size.width
            self.layer.addSublayer(bottomBorder)
            self.layer.masksToBounds = false
        }
    }
    
    private func animateTitle(_ style: AnimateStyle){
        
        overHolderLabel.alpha = (style == .show) ? 0 : 1
        overHolderLabel.transform = (style == .show) ? CGAffineTransform(translationX: 0, y: 10) : .identity
        
        let transform = (style == .show) ? .identity : CGAffineTransform(translationX: 100, y: 10)
        let alpha: CGFloat = (style == .show) ? 1 : 0
        
        UIView.animate(withDuration: 0.1) {
            self.overHolderLabel.alpha = alpha
            self.overHolderLabel.transform = transform
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if numberOfChars == characterLimit {
            if #available(iOS 10.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                shakeThat()
            } else {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                shakeThat()
            }
        }
        return numberOfChars < characterLimit
    }

    fileprivate func shakeThat() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
    
}
