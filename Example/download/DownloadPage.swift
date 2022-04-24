//
//  DownloadPage.swift
//  Example
//
//  Created by admin on 4/24/22.
//

import UIKit
import LXDowanloader
import LXM3U8

class DownloadPage: page {
    enum Item : String {
        case common
        case m3u8
    }
    lazy var table: UITableView = {
        let table = UITableView.init(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        table.tableFooterView = UIView()
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
        table.lx_tiling()
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
//        let link = "https://new.iskcd.com/20220408/1M9NVcM7/index.m3u8"
        let link = "https://devstreaming-cdn.apple.com/videos/wwdc/2021/10143/8/02A20AB5-0C7F-4E9F-B252-75A25D1261ED/downloads/wwdc2021-10143_sd.mp4?dl=1"
        guard let url = URL(string: link) else { return }
        if item == .common {
            let task = LXCommonDownloadTask.task(with: url)
            LXDowanloader.default.download(with: task)
        }
    }
    
    
    
    
    
    
}
