//
//  TableViewController.swift
//  FlexLayoutDemo1
//
//  Created by darkhandz on 2018/7/13.
//  Copyright © 2018年 darkhandz. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FlexLayoutDemo1"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(IntroViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(TaobaoSearchVC(), animated: true)
        case 2:
            navigationController?.pushViewController(BCZViewController(), animated: true)
        default:
            break
        }
    }

}
