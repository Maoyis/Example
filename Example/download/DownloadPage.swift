//
//  DownloadPage.swift
//  Example
//
//  Created by admin on 4/24/22.
//

import UIKit
import LXDowanloader
import LXM3U8

class DownloadPage: UIViewController {
    enum Item : String {
        case common
        case m3u8
    }
    lazy var table: UITableView = {
        let table = UITableView.init(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        view.addSubview(table)
        table.dataSource = self
        table.delegate   = self
        return table
    }()
    
    let data:[Item] = [
        .common
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "下载"
        table.tableFooterView = UIView()
    }


}



extension DownloadPage : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = data[indexPath.item].rawValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section]
        let link = "https://new.iskcd.com/20220408/1M9NVcM7/index.m3u8"
        guard let url = URL(string: link) else { return }
        if item == .common {
            let task = LXCommonDownloadTask.task(with: url)
            LXDowanloader.init().download(with: task)
        }
    }
    
    
    
    
    
    
}
