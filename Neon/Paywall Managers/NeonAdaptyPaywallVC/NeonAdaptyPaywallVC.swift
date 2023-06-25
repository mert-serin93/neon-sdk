//
//  NeonAdaptyPaywallVC.swift
//  neonApps-chatgpt
//
//  Created by Tuna Öztürk on 25.06.2023.
//

import Foundation
import UIKit
import Adapty

@available(iOS 13.0, *)
public class NeonAdaptyPaywallVC : UIViewController, AdaptyManagerDelegate{

    let btnWeekly = NeonAdaptyPaywallButton()
    let btnLifetime = NeonAdaptyPaywallButton()
    let titleLabel = UILabel()
    let btnBuy = NeonBouncingButton()
    var completionAfterShowingPaywall : (() -> ())?
    public override func viewDidLoad() {
        super.viewDidLoad()
        AdaptyManager.selectedPaywall = AdaptyManager.getPaywall(id: AdaptyPaywallBuilder.shared.paywallID)
        createUI()
        packageFetched()
        Neon.onboardingCompleted()
        if let paywall = AdaptyManager.selectedPaywall{
            Adapty.logShowPaywall(paywall)
        }
    }
    
    func createUI(){

        let backgroundImage = UIImageView()
        backgroundImage.image =  AdaptyPaywallBuilder.shared.isDarkModeEnabled ?  UIImage(named: "paywall_1_background_dark") : UIImage(named: "paywall_1_background_light")
        view.addSubview(backgroundImage)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.textAlignment = .center
        titleLabel.text = AdaptyPaywallBuilder.shared.titleLabelTextWhenWeeklySelected
        titleLabel.numberOfLines = 2
        titleLabel.font = Font.custom(size: 30, fontWeight: .SemiBold)
        titleLabel.textColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ? .white : .black
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            
        }
        
        createAnimatedViews()
        
        let testemonialView = NeonTestemonialView()
        view.addSubview(testemonialView)
        testemonialView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(210)
        }
        
    
        testemonialView.testemonialTextColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ?  .white : .black
        testemonialView.testemonialbackgroundColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ?  AdaptyPaywallBuilder.shared.darkColor : AdaptyPaywallBuilder.shared.lightColor
        testemonialView.currentTestemonialPageTintColor = AdaptyPaywallBuilder.shared.mainColor
        testemonialView.testemonialPageTintColor = .darkGray
        testemonialView.testemonialbackgroundCornerRadious = 12
        testemonialView.pageControlType = .V1
        
        testemonialView.addTestemonial(title: AdaptyPaywallBuilder.shared.testemonial1.title, testemonial: AdaptyPaywallBuilder.shared.testemonial1.testemonial, author: AdaptyPaywallBuilder.shared.testemonial1.author)
        testemonialView.addTestemonial(title: AdaptyPaywallBuilder.shared.testemonial2.title, testemonial: AdaptyPaywallBuilder.shared.testemonial2.testemonial, author: AdaptyPaywallBuilder.shared.testemonial2.author)
        testemonialView.addTestemonial(title: AdaptyPaywallBuilder.shared.testemonial3.title, testemonial: AdaptyPaywallBuilder.shared.testemonial3.testemonial, author: AdaptyPaywallBuilder.shared.testemonial3.author)

  
        let legalView = NeonLegalView()
        legalView.termsURL = AdaptyPaywallBuilder.shared.termsURL
        legalView.privacyURL = AdaptyPaywallBuilder.shared.privacyURL
        legalView.restoreButtonClicked = {
            AdaptyManager.restorePurchases(vc: self, animation: .loadingCircle, animationColor: AdaptyPaywallBuilder.shared.mainColor) {
                self.present(destinationVC: AdaptyPaywallBuilder.shared.homeVC, slideDirection: .right)
            } completionFailure: {
                
            }
        }
        legalView.textColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ? .white : .black
        view.addSubview(legalView)
        legalView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
      
        btnBuy.setTitle(AdaptyPaywallBuilder.shared.ctaButtonTextWhenWeeklySelected, for: .normal)
        btnBuy.titleLabel?.font = Font.custom(size: 16, fontWeight: .SemiBold)
        btnBuy.backgroundColor = AdaptyPaywallBuilder.shared.mainColor
        btnBuy.setTitleColor(.white, for: .normal)
        btnBuy.layer.cornerRadius = 12
        btnBuy.bouncingScale = AdaptyPaywallBuilder.shared.ctaButtonBouncedScale
        btnBuy.bouncingDuration = AdaptyPaywallBuilder.shared.ctaButtonBouncingDuration
        btnBuy.addTarget(self, action: #selector(btnBuyClicked), for: .touchUpInside)
        view.addSubview(btnBuy)
        btnBuy.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalTo(legalView.snp.top).offset(0)
            make.height.equalTo(60)
        }
        
        let lblFreeTrial = UILabel()
        lblFreeTrial.textAlignment = .left
        lblFreeTrial.text = "Enable Free Trial"
        lblFreeTrial.numberOfLines = 1
        lblFreeTrial.font = Font.custom(size: 15, fontWeight: .Medium)
        lblFreeTrial.textColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ? .white : .black
        view.addSubview(lblFreeTrial)
        lblFreeTrial.snp.makeConstraints { make in
            make.bottom.equalTo(btnBuy.snp.top).offset(-30)
            make.left.equalToSuperview().inset(40)
            
        }
        
        let switchFreeTrial = UISwitch()
        switchFreeTrial.isOn = true
        view.addSubview(switchFreeTrial)
        switchFreeTrial.addTarget(self, action: #selector(switchFreeTrialClicked(_ :)), for: .valueChanged)
        switchFreeTrial.snp.makeConstraints { make in
            make.centerY.equalTo(lblFreeTrial)
            make.right.equalToSuperview().inset(40)
            
        }
     
        btnLifetime.title = "Lifetime - \(AdaptyManager.getPackagePrice(id: AdaptyPaywallBuilder.shared.lifetimeProductID)) billed once"
        btnLifetime.subtitle = "Unlock Premium Features"
        view.addSubview(btnLifetime)
        btnLifetime.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalTo(switchFreeTrial.snp.top).offset(-20)
            make.height.equalTo(65)
        }
        btnLifetime.clickCompletion = { [self] in
            AdaptyManager.selectPackage(id: AdaptyPaywallBuilder.shared.lifetimeProductID)
            titleLabel.text = AdaptyPaywallBuilder.shared.titleLabelTextWhenLifetimeSelected
            btnBuy.setTitle(AdaptyPaywallBuilder.shared.ctaButtonTextWhenLifetimeSelected, for: .normal)
            switchFreeTrial.setOn(false, animated: true)
        }
      
        btnWeekly.title = "\(AdaptyManager.getPackagePrice(id: AdaptyPaywallBuilder.shared.weeklyProductID)) per week"
        btnWeekly.subtitle = "3-day free trial"
        btnWeekly.isSelected = true
        view.addSubview(btnWeekly)
        btnWeekly.isBestSeller = true
        btnWeekly.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalTo(btnLifetime.snp.top).offset(-20)
            make.height.equalTo(65)
        }
        btnWeekly.clickCompletion = { [self] in
            AdaptyManager.selectPackage(id: AdaptyPaywallBuilder.shared.weeklyProductID)
            titleLabel.text = AdaptyPaywallBuilder.shared.titleLabelTextWhenWeeklySelected
            btnBuy.setTitle(AdaptyPaywallBuilder.shared.ctaButtonTextWhenWeeklySelected, for: .normal)
            switchFreeTrial.setOn(true, animated: true)
        }
        
        
        let featuresView = NeonPaywallFeaturesView()
        featuresView.featureTextColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ? .white : .black
        featuresView.featureIconBackgroundColor = AdaptyPaywallBuilder.shared.mainColor
        featuresView.featureIconTintColor = .white
        view.addSubview(featuresView)
        featuresView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(testemonialView.snp.bottom).offset(5)
            make.bottom.equalTo(btnWeekly.snp.top).offset(-10)
        }
        featuresView.addFeature(title: AdaptyPaywallBuilder.shared.feature1.title, icon: AdaptyPaywallBuilder.shared.feature1.icon)
        featuresView.addFeature(title: AdaptyPaywallBuilder.shared.feature2.title, icon: AdaptyPaywallBuilder.shared.feature2.icon)
      
        if UIScreen.main.bounds.height > 812{ // iPhone X
            featuresView.addFeature(title: AdaptyPaywallBuilder.shared.feature3.title, icon: AdaptyPaywallBuilder.shared.feature3.icon)
        }
       
        if UIScreen.main.bounds.height <= 667{ // iPhone 8
            featuresView.addFeature(title: AdaptyPaywallBuilder.shared.feature3.title, icon: AdaptyPaywallBuilder.shared.feature3.icon)
            testemonialView.isHidden = true
            
            featuresView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
                make.bottom.equalTo(btnWeekly.snp.top).offset(-10)
            }
        }
        
        createCloseButton()
    }
    
    @objc func btnBuyClicked(){
        if AdaptyManager.selectedPackage == nil{
            AdaptyManager.selectPackage(id: AdaptyPaywallBuilder.shared.weeklyProductID)
        }
        AdaptyManager.subscribe(animation: .loadingCircle, animationColor: AdaptyPaywallBuilder.shared.mainColor) { [self] in
            if AdaptyPaywallBuilder.shared.canDismiss{
                dismiss(animated: true)
            }else{
                self.present(destinationVC: AdaptyPaywallBuilder.shared.homeVC, slideDirection: .down)
            }
        } completionFailure: {
         
        }

    }
    func createAnimatedViews(){
        let sparkle1 = NeonAnimationView(animation: .custom(name: "sparkle_1"), color: AdaptyPaywallBuilder.shared.mainColor)
        view.addSubview(sparkle1)
        sparkle1.alpha = 0.4
        sparkle1.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(150)
            make.right.equalToSuperview().offset(10)
        }
        
        let sparkle2 = NeonAnimationView(animation: .custom(name: "sparkle_2"), color: AdaptyPaywallBuilder.shared.mainColor)
        view.addSubview(sparkle2)
        sparkle2.alpha = 0.4
        sparkle2.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.bottom)
            make.width.height.equalTo(100)
            make.left.equalTo(titleLabel.snp.left).offset(-20)
        }
        
        let sparkle3 = NeonAnimationView(animation: .custom(name: "sparkle_1"), color:  AdaptyPaywallBuilder.shared.mainColor)
        view.addSubview(sparkle3)
        sparkle3.alpha = 0.4
        sparkle3.transform = CGAffineTransform(scaleX: -1, y: 1)
        sparkle3.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.bottom).offset(50)
            make.width.height.equalTo(150)
            make.right.equalTo(titleLabel.snp.right).offset(20)
        }
        
    }
    
    func createCloseButton(){
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        let closeButtonAlpha = AdaptyPaywallBuilder.shared.closeButtonAlpha
        closeButton.alpha = closeButtonAlpha
        closeButton.tintColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ? .white : .black
        closeButton.addAction { [self] in
            if AdaptyPaywallBuilder.shared.canDismiss{
    
                dismiss(animated: true)
                
                if let completionAfterShowingPaywall{
                    completionAfterShowingPaywall()
                }
      
            }else{
                present(destinationVC: AdaptyPaywallBuilder.shared.homeVC, slideDirection: .right)
            }
        }
      
        let closeButtonAppearanceDuration = AdaptyPaywallBuilder.shared.closeButtonAppearanceDuration
        if closeButtonAppearanceDuration != 0{
            closeButton.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + closeButtonAppearanceDuration , execute: {
            closeButton.isHidden = false
        })
        view.addSubview(closeButton)
        let closeButtonSize = AdaptyPaywallBuilder.shared.closeButtonSize
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(10)
            make.height.width.equalTo(closeButtonSize)
        }
        
        
    }
    @objc func switchFreeTrialClicked(_ sender : UISwitch ){
        if sender.isOn{
            btnWeekly.clicked()
        }else{
            btnLifetime.clicked()
        }
    }
    
    public func packageFetched() {
        btnLifetime.title = "Lifetime - \(AdaptyManager.getPackagePrice(id: AdaptyPaywallBuilder.shared.lifetimeProductID)) billed once"
        btnWeekly.title = "\(AdaptyManager.getPackagePrice(id: AdaptyPaywallBuilder.shared.weeklyProductID)) per week"
    }
    
}
