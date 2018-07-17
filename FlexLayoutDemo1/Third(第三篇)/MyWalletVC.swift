//
//  MyWalletVC.swift
//  FlexLayoutDemo1
//
//  Created by darkhandz on 2018/7/17.
//  Copyright © 2018年 darkhandz. All rights reserved.
//

import UIKit

class MyWalletVC: UIViewController {
    
    var mainView: MyWalletView { return self.view as! MyWalletView }
    override func loadView() { self.view = MyWalletView() }

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        automaticallyAdjustsScrollViewInsets = false
        mainView.remainDaysLabel.text = "月卡剩余51天"
        mainView.balanceLabel.text = "4.00元"
        mainView.bonusLabel.text = "0.63元"
        mainView.wxPassStateLabel.text = "已开通"
        
        mainView.onBalanceClicked = { [unowned self] in
            print(self.mainView.balanceLabel.text ?? "")
        }
        mainView.onBonusClicked = { [unowned self] in
            print(self.mainView.bonusLabel.text ?? "")
        }
        mainView.onWXPassStateClicked = { [unowned self] in
            print(self.mainView.wxPassStateLabel.text ?? "")
        }
        // 查看按钮
        mainView.daysDetailBtn
            .addTarget(self, action: #selector(monthCardDetailClicked), for: .touchUpInside)
    }
    
    @objc private func monthCardDetailClicked() {
        print("查看月卡详情")
    }
}
