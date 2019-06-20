//
//  SiriButtonView.swift
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 23/10/2018.
//  Modified by Jaime Agudo on 20/06/2019
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation
import Intents
import IntentsUI
import UIKit

@available(iOS 12.0, *)
@objc(SiriButtonView)
public class SiriButtonView : UIView {
    var defaultStyle: INUIAddVoiceShortcutButtonStyle = .blackOutline
    var button: INUIAddVoiceShortcutButton
    var onPress: RCTBubblingEventBlock?
    let slate =  UIColor(red: 51.0/255, green: 73.0/255, blue: 91.0/255, alpha:1)
    var isCentered: Bool = false;
    
    override init(frame: CGRect) {
        button = INUIAddVoiceShortcutButton(style: defaultStyle)
        
        super.init(frame: frame)
        setupButton(style: defaultStyle)
    }
    
    func setupButton(style: INUIAddVoiceShortcutButtonStyle? = nil, shortcut: INShortcut? = nil) {
        // Remove from container before re-declaring
        button.removeFromSuperview()
        // Set from the predefined styles
        
        //'blackOutline' meaning redefined to be black&centered to save a 'isCentered' parameter; outline style are unused
        if(style == .blackOutline){
            isCentered = true
            button = INUIAddVoiceShortcutButton(style: .black)
            // Remove constraints so that the button renders with the default size Apple intended
            button.translatesAutoresizingMaskIntoConstraints = false
        } else {
            button = INUIAddVoiceShortcutButton(style: style ?? defaultStyle)
        }
        
        // Wire up with the JS onTap
        button.addTarget(self, action: #selector(SiriButtonView.onClick), for: .touchUpInside)
        // Add the shortcut, if provided
        button.shortcut = shortcut
        
        //Tweak native button style to match RN style
        for subview in button.subviews {
            if !self.isCentered, let image = subview as? UIImageView{
                image.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.6).isActive = true
                image.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.6).isActive = true
                image.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 12.0).isActive = true
            }
            if let label = subview as? UILabel, let text = label.text {
                if text.contains("Siri") {
                    label.font = UIFont(name: "bariol-medium", size: 18)
                    if style == .white {
                        label.textColor = slate
                    }
                }else {
                    label.font = UIFont(name: "bariol-medium", size: 13)
                }
                if !self.isCentered{
                    label.adjustsFontSizeToFitWidth = false
                    label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 64.0).isActive = true
                }
            }
        }
        self.addSubview(button)
    }
    
    @objc(setButtonStyle:)
    public func setButtonStyle(_ buttonStyle: NSNumber) {
        let style = INUIAddVoiceShortcutButtonStyle.init(rawValue: buttonStyle.uintValue)
        setupButton(style: style, shortcut: button.shortcut)
    }
    
    @objc(setOnPress:)
    public func setOnPress(_ onPress: @escaping RCTBubblingEventBlock) {
        self.onPress = onPress
    }
    
    @objc(setShortcut:)
    public func setShortcut(_ jsonOptions: Dictionary<String, Any>) {
        let activity = ShortcutsModule.generateUserActivity(jsonOptions)
        let shortcut = INShortcut(userActivity: activity)
        setupButton(style: self.button.style, shortcut: shortcut)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add the button as a subview
    public override func layoutSubviews() {
        super.layoutSubviews()
        if(isCentered){
            // Center button in view
            self.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            self.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        }else {
            // Make the button to take all available space
            button.frame = self.bounds
        }
    }
    
    @objc func onClick() {
        onPress?(nil)
    }
}
