//
//  TaobaoSearchVC.swift
//  FlexLayoutDemo1
//
//  Created by darkhandz on 2018/7/13.
//  Copyright © 2018年 darkhandz. All rights reserved.
//

import UIKit
import FlexLayout


class TaobaoSearchVC: UIViewController {
    
    let rootFlexContainer = UIView()
    private var historyTagButtons = [UIButton]()
    private var discoverTagButtons = [UIButton]()
    private let tagButtonHeight: CGFloat = 26
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    
    private func configUI() {
        view.backgroundColor = UIColor(white: 0.98, alpha: 1)
        view.addSubview(rootFlexContainer)
        
        let historyTags = ["20寸 自行车 定速", "U盘 slc", "充值 广东电信 100", "g602 罗技", "ps4", "Windows10 专业版", "sm981", "darkhandz"]
        let discoverTags = ["英国mua", "车用吸尘器", "手表清洗工具", "f强人指甲钳", "小吸尘器", "宁哥同款眼镜", "思美兰唇釉", "尤文图斯球衣18-19"]
        
        let histLabel = UILabel()
        histLabel.font = UIFont.systemFont(ofSize: 14)
        histLabel.textColor = UIColor(white: 0.3, alpha: 1)
        histLabel.text = "历史搜素"
        
        let disLabel = UILabel()
        disLabel.font = UIFont.systemFont(ofSize: 14)
        disLabel.textColor = UIColor(white: 0.3, alpha: 1)
        disLabel.text = "搜素发现"
        
        let delButton = UIButton()
        delButton.setImage(UIImage(named: "delete"), for: .normal)
        let seeButton = UIButton()
        seeButton.setImage(UIImage(named: "eye"), for: .normal)
        
        for tag in historyTags {
            let btn = createTagButton()
            btn.setTitle(tag, for: .normal)
            historyTagButtons.append(btn)
        }
        for tag in discoverTags {
            let btn = createTagButton()
            btn.setTitle(tag, for: .normal)
            discoverTagButtons.append(btn)
        }
        
        rootFlexContainer.flex.padding(10).define { flex in
            flex.addItem().direction(.row).justifyContent(.spaceBetween).define { flex in
                flex.addItem(histLabel)
                flex.addItem(delButton)
            }
            flex.addItem().direction(.row).wrap(.wrap).marginBottom(15).define { flex in
                for btn in historyTagButtons {
                    flex.addItem(btn).marginRight(10).paddingHorizontal(12).marginTop(10)
                }
            }
            flex.addItem().direction(.row).justifyContent(.spaceBetween).define { flex in
                flex.addItem(disLabel)
                flex.addItem(seeButton)
            }
            flex.addItem().direction(.row).wrap(.wrap).marginBottom(15).define { flex in
                for btn in discoverTagButtons {
                    flex.addItem(btn).marginRight(8).paddingHorizontal(12).marginTop(10)
                }
            }
        }
    }
    
    
    private func createTagButton() -> UIButton {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.backgroundColor = UIColor(white: 0.92, alpha: 1)
        btn.layer.cornerRadius = tagButtonHeight / 2
        btn.layer.masksToBounds = true
        return btn
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
