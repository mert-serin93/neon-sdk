//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 8.06.2023.
//

import Foundation
import UIKit

public class NeonLegalView : UIView{
    
    public var termsURL = String()
    public var privacyURL = String()
    public var textColor = UIColor.black{
        didSet{
            termsButton.setTitleColor(textColor, for: .normal)
            restoreButton.setTitleColor(textColor, for: .normal)
            privacyButton.setTitleColor(textColor, for: .normal)
        }
    }
    public var restoreButtonClicked : (()->())?
    
    public let privacyButton = UIButton()
    public let restoreButton = UIButton()
    public let termsButton = UIButton()
    
    public  init() {
        super.init(frame: .zero)
        setupView()
    }
    
    func setupView(){
        
        
        let attributedTitle = NSAttributedString(string: "Privacy Policy".localized(), attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        privacyButton.setAttributedTitle(attributedTitle, for: .normal)
        privacyButton.setTitleColor(textColor, for: .normal)
        privacyButton.titleLabel?.font = Font.custom(size: 10, fontWeight: .Regular)
        addSubview(privacyButton)
        privacyButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        privacyButton.addTarget(self, action: #selector(privacyButtonClicked), for: .touchUpInside)
       
        let attributedTitle2 = NSAttributedString(string: "Restore Purchases".localized(), attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        restoreButton.setAttributedTitle(attributedTitle2, for: .normal)
        restoreButton.setTitleColor(textColor, for: .normal)
        restoreButton.titleLabel?.font = Font.custom(size: 10, fontWeight: .Regular)
        addSubview(restoreButton)
        restoreButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        restoreButton.addTarget(self, action: #selector(restoreClicked), for: .touchUpInside)
     
        let attributedTitle3 = NSAttributedString(string: "Terms of Use".localized(), attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        termsButton.setAttributedTitle(attributedTitle3, for: .normal)
        termsButton.setTitleColor(textColor, for: .normal)
        termsButton.titleLabel?.font = Font.custom(size: 10, fontWeight: .Regular)
        addSubview(termsButton)
        termsButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        termsButton.addTarget(self, action: #selector(termsButtonClicked), for: .touchUpInside)
    }
    
    @objc func privacyButtonClicked(){
        SettingsManager.openLinkFromBrowser(url: privacyURL)
    }
    @objc func restoreClicked(){
        if let restoreButtonClicked{
            restoreButtonClicked()
        }
    }
    @objc func termsButtonClicked(){
        SettingsManager.openLinkFromBrowser(url: termsURL)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
