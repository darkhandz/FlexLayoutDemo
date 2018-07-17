//
//  NovelSummaryVC.swift
//  FlexLayoutDemo1
//
//  Created by darkhandz on 2018/7/13.
//  Copyright © 2018年 darkhandz. All rights reserved.
//

import UIKit
import FlexLayout


class NovelSummaryVC: UIViewController {
    fileprivate var rootFlex = UIView()
    fileprivate var summaryView = UIView()
    /// 背景图
    fileprivate let bgImgV = UIImageView(image: UIImage(named: "novel_bg"))
    /// 封面图
    fileprivate let coverImgV = UIImageView()
    /// 大V图标
    fileprivate let verifiedImgV = UIImageView(image: UIImage(named: "novel_v"))
    /// 浅红色view
    fileprivate let descContainer = UIView()
    /// 一句话描述作品
    fileprivate let descLabel = UILabel()
    /// 书名
    fileprivate let bookNameLabel = UILabel()
    /// 作者
    fileprivate let authorLabel = UILabel()
    /// 级别
    fileprivate let levelLabel = UILabel()
    /// 阅读量
    fileprivate let readCountLabel = UILabel()
    /// 分类
    fileprivate let categoryLabel = UILabel()
    /// 字数, 状态
    fileprivate let wordCoundAndStateLabel = UILabel()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.96, alpha: 1)
        view.addSubview(rootFlex)
        
        coverImgV.image = UIImage(named: "novel_cover")
        descLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        descLabel.text = "“玄门羽衣白云心，一琴一剑一丹青”"
        descLabel.textAlignment = .center
        descLabel.textColor = UIColor(0.77, 0.64, 0.48, 1)
        
        configLabel(bookNameLabel, text: "心魔")
        bookNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        configLabel(authorLabel, text: "沁纸花青")
        levelLabel.text = "Lv4"
        levelLabel.font = UIFont.systemFont(ofSize: 10)
        levelLabel.textColor = UIColor(0, 0.8, 1, 1)
        levelLabel.textAlignment = .center
        levelLabel.layer.borderColor = UIColor(0, 0.8, 1, 1).cgColor
        levelLabel.layer.borderWidth = 1
        levelLabel.layer.cornerRadius = 4
        levelLabel.layer.masksToBounds = true
        configLabel(readCountLabel, text: "466万人读过")
        configLabel(categoryLabel, text: "仙侠 | 幻想修真")
        configLabel(wordCoundAndStateLabel, text: "266.0万字 | 连载")
        
        
        rootFlex.flex.marginTop(64).define { flex in
            flex.addItem(summaryView).backgroundColor(.white).define { flex in
                flex.addItem(bgImgV).position(.absolute).left(0).top(0).width(100%).height(100%)
                // 浅绿色盒子, 横向排列子盒子, 距离父盒子(summaryView)左右外边距为15，顶底各12外边距
                flex.addItem().direction(.row).marginVertical(12).marginHorizontal(15).define { flex in
                    flex.addItem().marginRight(22).width(24.6%).aspectRatio(17/23).define { flex in
                        // 封面图, 右外边距22
                        flex.addItem(coverImgV)
                        flex.addItem(verifiedImgV).position(.absolute).right(-5).bottom(-5).size(20)
                    }
                    // 浅蓝色盒子
                    flex.addItem().justifyContent(.spaceBetween).grow(1).shrink(1).define { flex in
                        flex.addItem(bookNameLabel)
                        flex.addItem().direction(.row).define { flex in
                            flex.addItem(authorLabel)
                            flex.addItem(levelLabel).paddingHorizontal(6).marginLeft(8)
                        }
                        flex.addItem(readCountLabel)
                        flex.addItem(categoryLabel)
                        flex.addItem(wordCoundAndStateLabel)
                    }
                }
                // 浅红色盒子, padding(上, 左, 下, 右)
                flex.addItem(descContainer).padding(12, 10, 8, 10)
                    .backgroundColor(.black).define { flex in
                    flex.addItem(descLabel)
                }
            }
            flex.addItem().grow(1).backgroundColor(.lightGray)
        }
        
        // 模拟不需要显示底部浅红色view
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.descContainer.flex.isIncludedInLayout = false
            self.descContainer.isHidden = true
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlex.frame = view.bounds
        rootFlex.flex.layout()
    }
    
    
    fileprivate func configLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
    }
}
