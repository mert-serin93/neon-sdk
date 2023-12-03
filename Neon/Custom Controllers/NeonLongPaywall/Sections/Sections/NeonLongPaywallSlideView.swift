//
//  NeonLongPaywallSlideView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 3.12.2023.
//

import Foundation
import UIKit

@available(iOS 15.0, *)
class NeonLongPaywallSlideView : BaseNeonLongPaywallSectionView{
    
    
     let slidesView = NeonSlideView()
    
    override func configureSection(type: NeonLongPaywallSectionType) {
        
        configureView()
        switch type {
        case .slide(let height,let showBeforeAfterBadges, let items):
            
            addSubview(slidesView)
            slidesView.showBeforeAfterBadges = showBeforeAfterBadges
            slidesView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(height)
            }
            
 
            items.forEach { item in
                slidesView.addSlide(firstImage: item.firstImage, secondImage: item.secondImage, title: item.title, subtitle: item.subtitle)
            }
            
            break
        default:
            fatalError("Something went wrong with NeonLongPaywall. Please consult to manager.")
        }
        
        setConstraint()
    }
    
    private func configureView() {
        
       
        
        slidesView.textColor = NeonLongPaywallConstants.primaryTextColor
        slidesView.beforeAfterBadgesTextColor = NeonLongPaywallConstants.ctaButtonTextColor
        slidesView.slideBackgroundColor = NeonLongPaywallConstants.containerColor
        slidesView.mainColor = NeonLongPaywallConstants.mainColor
        slidesView.pageTintColor = NeonLongPaywallConstants.secondaryTextColor
        slidesView.slideBackgroundCornerRadious = Int(NeonLongPaywallConstants.cornerRadius)
        slidesView.pageControlType = .V1
        
     }
    func setConstraint(){
        snp.makeConstraints { make in
            make.bottom.equalTo(slidesView.snp.bottom)
        }
    }
    
}