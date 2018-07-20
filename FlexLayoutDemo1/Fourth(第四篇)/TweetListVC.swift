//
//  TweetListVC.swift
//  FlexLayoutDemo1
//
//  Created by darkhandz on 2018/7/18.
//  Copyright © 2018年 darkhandz. All rights reserved.
//

import UIKit

class TweetListVC: UIViewController {
    
    fileprivate let tbv = UITableView(frame: .zero, style: .grouped)
    fileprivate let cellTemplate = TweetCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "动态"
        configUI()
    }
    
    private func configUI() {
        view.addSubview(tbv)
        tbv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        //tbv.rowHeight = UITableView.automaticDimension
        tbv.estimatedRowHeight = 300
        tbv.estimatedSectionFooterHeight = 0
        tbv.estimatedSectionHeaderHeight = 0
        tbv.separatorStyle = .none
        tbv.register(TweetCell.self, forCellReuseIdentifier: "\(TweetCell.self)")
        tbv.delegate = self
        tbv.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tbv.frame = view.bounds
    }

}



extension TweetListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TweetStore.shared.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = TweetStore.shared.item(at: indexPath.section)
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TweetCell.self)", for: indexPath) as! TweetCell
        cell.configWith(item)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = TweetStore.shared.item(at: indexPath.section)
        if let height = item.cellHeight { return height }
        cellTemplate.configWith(item)
        let size = cellTemplate.sizeThatFits(CGSize(width: tableView.bounds.width,
                                                    height: CGFloat.greatestFiniteMagnitude))
        item.cellHeight = size.height
        return size.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
