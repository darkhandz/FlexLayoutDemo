//
//  MyWalletView.swift
//  FlexLayoutDemo1
//
//  Created by darkhandz on 2018/7/17.
//  Copyright © 2018年 darkhandz. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout


class MyWalletView: UIView {
    
    fileprivate let rootFlex = UIView()
    fileprivate let mainScroll = UIScrollView()
    fileprivate let mainContainer = UIView()
    /// 月卡信息容器
    fileprivate let cardInfoContainer = UIView()
    let remainDaysLabel = UILabel()
    let daysDetailBtn = UIButton(type: .system)
    
    /// 余额
    private(set) var balanceLabel: UILabel!
    /// 我的红包
    private(set) var bonusLabel: UILabel!
    /// 微信免密状态
    private(set) var wxPassStateLabel: UILabel!
    
    /// 点击余额回调
    var onBalanceClicked: (()->Void)?
    /// 点击红包回调
    var onBonusClicked: (()->Void)?
    /// 点击微信免密回调
    var onWXPassStateClicked: (()->Void)?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("未实现")
    }
    
    func configUI() {
        backgroundColor = .white
        mainContainer.backgroundColor = UIColor(white: 0.96, alpha: 1)
        addSubview(rootFlex)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        titleLabel.text = "我的钱包"
        titleLabel.textColor = .black
        
        let posterImgV = UIImageView(image: UIImage(named: "bike_bg"))
        
        let posterTitleLabel = UILabel()
        posterTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        posterTitleLabel.text = "黑手单车·月卡"
        posterTitleLabel.textColor = .white
        
        let posterSubtitleLabel = UILabel()
        posterSubtitleLabel.font = UIFont.systemFont(ofSize: 20)
        posterSubtitleLabel.text = "mmbike"
        posterSubtitleLabel.textColor = .white
        
        cardInfoContainer.layer.cornerRadius = 12
        cardInfoContainer.layer.shadowOpacity = 0.1
        cardInfoContainer.layer.shadowColor = UIColor.gray.cgColor
        cardInfoContainer.layer.shadowOffset = CGSize(width: 0, height: 1)
        cardInfoContainer.layer.shadowRadius = 12
        
        let cardTitleLabel = UILabel()
        cardTitleLabel.font = UIFont.systemFont(ofSize: 14)
        cardTitleLabel.text = "黑手单车月卡"
        cardTitleLabel.textColor = UIColor(white: 0.3, alpha: 1)
        
        remainDaysLabel.font = UIFont.systemFont(ofSize: 14)
        remainDaysLabel.text = "月卡剩余0天"
        remainDaysLabel.textColor = .gray
        
        let tipsLabel = UILabel()
        tipsLabel.font = UIFont.systemFont(ofSize: 12)
        tipsLabel.text = "骑行更划算！"
        tipsLabel.textColor = .red
        
        daysDetailBtn.setTitle("查看", for: .normal)
        daysDetailBtn.setTitleColor(UIColor(white: 0.3, alpha: 1), for: .normal)
        daysDetailBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        daysDetailBtn.layer.cornerRadius = 18
        daysDetailBtn.layer.masksToBounds = true
        daysDetailBtn.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        let (balanceView, balanceBtn, balanceLabel) = createCell(title: "余额", subtitle: "0.00元")
        let (bonusView, bonusBtn, bonusLabel) = createCell(title: "我的红包", subtitle: "0.00元")
        let (wxView, wxBtn, wxLabel) = createCell(title: "微信免密", subtitle: "未开通")
        let (moreView1, _, _) = createCell(title: "支付宝免密", subtitle: "未开通")
        let (moreView2, _, _) = createCell(title: "银联免密", subtitle: "未开通")
        
        // 赋值方便以后控制
        self.balanceLabel = balanceLabel
        self.bonusLabel = bonusLabel
        self.wxPassStateLabel = wxLabel
        // 绑定点击事件
        balanceBtn.addTarget(self, action: #selector(balanceButtonClick), for: .touchUpInside)
        bonusBtn.addTarget(self, action: #selector(bonusButtonClick), for: .touchUpInside)
        wxBtn.addTarget(self, action: #selector(wxStateButtonClick), for: .touchUpInside)
        
        let lockIcon = UIImageView(image: UIImage(named: "bike_lock"))
        let depositLabel = UILabel()
        depositLabel.font = UIFont.systemFont(ofSize: 13)
        depositLabel.textColor = UIColor(white: 0.5, alpha: 1)
        depositLabel.text = "已交押金, 可享有平台各种会员服务"
        let depositDetailBtn = UIButton(type: .system)
        depositDetailBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        depositDetailBtn.setTitleColor(.darkGray, for: .normal)
        depositDetailBtn.setTitle("查看", for: .normal)
        depositDetailBtn.layer.cornerRadius = 4
        depositDetailBtn.layer.masksToBounds = true
        depositDetailBtn.layer.borderColor = UIColor.darkGray.cgColor
        depositDetailBtn.layer.borderWidth = 0.5
        
        
        // 主框架结构
        rootFlex.flex.define { flex in
            flex.addItem(mainScroll).grow(1).shrink(1).define { flex in
                flex.addItem(mainContainer)
            }
            flex.addItem().direction(.row).alignItems(.center).height(60)
                .backgroundColor(UIColor(white: 0.93, alpha: 1)).define { flex in
                flex.addItem(lockIcon).width(20).marginHorizontal(20).aspectRatio(of: lockIcon)
                flex.addItem(depositLabel).marginRight(20).grow(1).shrink(1)
                flex.addItem(depositDetailBtn).paddingHorizontal(10).marginRight(14)
            }
        }
        
        // 内容结构
        mainContainer.flex.paddingHorizontal(20).define { flex in
            flex.addItem(titleLabel).marginTop(30).marginBottom(18)
            flex.addItem(posterImgV).width(100%).aspectRatio(67/40).marginBottom(15).define { flex in
                flex.addItem(posterTitleLabel).marginTop(16).marginLeft(20)
                flex.addItem(posterSubtitleLabel).position(.absolute).left(20).bottom(16)
            }
            flex.addItem(cardInfoContainer).direction(.row).padding(20, 20, 20, 14)
                .backgroundColor(.white).define { flex in
                // 月卡标题, 剩余天数
                flex.addItem().define { flex in
                    flex.addItem(cardTitleLabel)
                    flex.addItem(remainDaysLabel).marginTop(4)
                }
                // 占位
                flex.addItem().grow(1).shrink(1)
                // 骑行更划算
                flex.addItem(tipsLabel)
                // 查看按钮
                flex.addItem(daysDetailBtn).marginLeft(14).paddingHorizontal(13)
            }
            flex.addItem(balanceView)
            flex.addItem(bonusView)
            flex.addItem(wxView)
            flex.addItem(moreView1)
            flex.addItem(moreView2)
        }
    }
    
    func layout() {
        rootFlex.flex.margin(pin.safeArea)
        rootFlex.flex.layout()
        mainContainer.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        rootFlex.frame.size = size
        layout()
        return rootFlex.frame.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlex.frame = bounds
        layout() // 进行rootFlex布局计算
        // 布局完成之后
        mainScroll.contentSize = mainContainer.bounds.size
    }
}




extension MyWalletView {
    
    fileprivate func createCell(title: String, subtitle: String) -> (UIView, UIButton, UILabel) {
        let btn = UIButton()
        let arrow = UIImageView(image: UIImage(named: "rightArrow"))
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor(white: 0.3, alpha: 1)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = UIColor(white: 0.3, alpha: 1)
        
        let v = UIView()
        v.flex.direction(.row).paddingHorizontal(15).height(55).define { flex in
            flex.addItem(titleLabel).grow(1).shrink(1)
            flex.addItem(subtitleLabel).marginHorizontal(10)
            flex.addItem(arrow).size(15).alignSelf(.center)
            // 分隔线
            flex.addItem().position(.absolute).height(0.5).width(100%).left(15).bottom(0)
                .backgroundColor(UIColor(white: 0.85, alpha: 1))
            flex.addItem(btn).position(.absolute).left(0).top(0).width(100%).height(100%)
        }
        return (v, btn, subtitleLabel)
    }
    
    @objc fileprivate func balanceButtonClick() {
        print("点击余额")
        onBalanceClicked?()
    }
    @objc fileprivate func bonusButtonClick() {
        print("点击红包")
        onBonusClicked?()
    }
    @objc fileprivate func wxStateButtonClick() {
        print("点击微信")
        onWXPassStateClicked?()
    }
}
