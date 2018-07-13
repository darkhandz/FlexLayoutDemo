//
//  BCZViewController.swift
//  FlexLayoutDemo1
//
//  Created by darkhandz on 2018/7/13.
//  Copyright © 2018年 darkhandz. All rights reserved.
//

import UIKit
import FlexLayout

let ScreenHeight = UIScreen.main.bounds.height
let ScreenWidth = UIScreen.main.bounds.width


class BCZViewController: UIViewController {
    
    let rootFlexContainer = UIView()
    private let buttonHeight: CGFloat = 44
    private(set) var wechatBtn: UIButton!
    private(set) var qqBtn: UIButton!
    private(set) var phoneBtn: UIButton!
    private(set) var loginBtn: UIButton!
    private(set) var otherBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        configUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // ...模拟: 检查到设备没有安装微信...
            self.hideButton(self.wechatBtn)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // ...模拟: 产品经理突然说不开放注册了, 只准登录...
            self.hideButton(self.phoneBtn)
        }
    }
    
    // 点击显示导航栏
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    private func configUI() {
        view.backgroundColor = UIColor(red: 0.97, green: 0.96, blue: 0.95, alpha: 1)
        view.addSubview(rootFlexContainer)
        
        let logoImgV = UIImageView(image: UIImage(named: "bcz_logo"))
        wechatBtn = createButton(title: "微信登录", bgColor: UIColor(0.1, 0.7, 0.04, 1))
        qqBtn     = createButton(title: "QQ登录", bgColor: UIColor(0.3, 0.38, 0.57, 1))
        phoneBtn  = createButton(title: "手机注册", bgColor: UIColor(0.26, 0.69, 0.96, 1))
        loginBtn  = createButton(title: "登录", bgColor: UIColor(0.26, 0.69, 0.96, 1))
        otherBtn = UIButton(type: .system)
        otherBtn.setTitle("其他账号登录", for: .normal)
        otherBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        otherBtn.setTitleColor(.gray, for: .normal)
        
        // 注意FlexBox的 marginTop, marginBottom 百分比指的是superview的宽度百分比
        // 每次用它俩的百分比都会导致莫名的坑, 所以暂不建议使用marginTop, marginBottom的百分比方法
        // 这里折中使用屏幕高度百分比来计算值
        rootFlexContainer.flex.alignItems(.center).define { flex in
            flex.addItem(logoImgV).width(30%).marginTop(ScreenHeight * 0.18).aspectRatio(1)
            flex.addItem().grow(1).shrink(1) // 占位弹簧
            flex.addItem().justifyContent(.center).width(73%)
                .height(24%).marginBottom(ScreenHeight * 0.1).define { flex in
                    flex.addItem(wechatBtn).height(buttonHeight).marginBottom(10)
                    flex.addItem(qqBtn).height(buttonHeight).marginBottom(10)
                    flex.addItem().direction(.row).height(buttonHeight).define { flex in
                        flex.addItem(phoneBtn).width(62%).marginRight(10)
                        flex.addItem(loginBtn).grow(1)
                    }
            }
            flex.addItem(otherBtn).marginBottom(20)
        }
    }
    
    
    func hideButton(_ btn: UIButton) {
        btn.flex.isIncludedInLayout = false
        btn.isHidden = true
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    private func createButton(title: String, bgColor: UIColor) -> UIButton {
        let btn = UIButton()
        btn.backgroundColor = bgColor
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.cornerRadius = 4
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
        rootFlexContainer.flex.layout(mode: .fitContainer)
    }
}




extension UIColor {
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) {
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

