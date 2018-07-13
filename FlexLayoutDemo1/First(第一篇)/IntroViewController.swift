//
//  IntroViewController.swift
//  FlexLayoutDemo1
//
//  Created by darkhandz on 2018/7/13.
//  Copyright © 2018年 darkhandz. All rights reserved.
//

import UIKit
import FlexLayout


class IntroViewController: UIViewController {
    
    fileprivate var rootFlexContainer = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    
    private func configUI() {
        view.backgroundColor = .white
        view.addSubview(rootFlexContainer)
        
        let imageView = UIImageView(image: UIImage(named: "flexlayout-logo"))
        
        let segmentedControl = UISegmentedControl(items: ["Intro", "FlexLayout", "PinLayout"])
        segmentedControl.selectedSegmentIndex = 0
        
        let label = UILabel()
        label.text = "Flexbox layouting is simple, powerfull and fast.\n\nFlexLayout syntax is concise and chainable."
        label.numberOfLines = 0
        
        let bottomLabel = UILabel()
        bottomLabel.text = "FlexLayout/yoga is incredibly fast, its even faster than manual layout."
        bottomLabel.numberOfLines = 0
        
        rootFlexContainer.flex.padding(12).define { flex in
            flex.addItem().direction(.row).define { flex in
                flex.addItem(imageView).width(100).aspectRatio(of: imageView)
                flex.addItem().paddingLeft(12).grow(1).shrink(1).define { flex in
                    flex.addItem(segmentedControl).marginBottom(12).grow(1)
                    flex.addItem(label)
                }
            }
            // 分隔线
            flex.addItem().height(1).marginTop(12).backgroundColor(.lightGray)
            flex.addItem(bottomLabel).marginTop(12)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11, *) {
            rootFlexContainer.flex.margin(view.safeAreaInsets)
        } else {
            rootFlexContainer.flex.margin(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
        }
        rootFlexContainer.frame = view.bounds
        rootFlexContainer.flex.layout(mode: .adjustHeight)
    }
}
