//
//  DownloadPage.swift
//  Example
//
//  Created by admin on 4/24/22.
//

import UIKit
import LXDownloader

class DownloadPage: page {
    enum Item : String {
        case common
        case m3u8
    }
    var downloader:LXDownloader = LXDownloader.default
    lazy var table: UITableView = {
        let table = UITableView.init(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        
        table.register(DownloadTaskCell.self, forCellReuseIdentifier: DownloadTaskCell.description())
        table.tableFooterView = UIView()
        view.addSubview(table)
        table.dataSource = self
        table.delegate   = self
        return table
    }()
    
    let data:[Item] = [
        .common, .m3u8
    ]
    var tasks:[LXDownloadTask] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "下载"
        table.lx_tiling()
        guard let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            fatalError("no cache floder")
        }
        var floder = URL(fileURLWithPath: cache)
        print(floder)
    }


}



extension DownloadPage : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return data.count
        }
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = data[indexPath.item].rawValue
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DownloadTaskCell.description(), for: indexPath) as! DownloadTaskCell
            let task = tasks[indexPath.item]
            task.delegate = cell
            cell.task = task
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let item = data[indexPath.item]
            var task:LXDownloadTask!
            if item == .common {
                let link = "https://devstreaming-cdn.apple.com/videos/wwdc/2021/10143/8/02A20AB5-0C7F-4E9F-B252-75A25D1261ED/downloads/wwdc2021-10143_sd.mp4?dl=1&time=\(Date.now.timeIntervalSince1970)"
                guard let url = URL(string: link) else { return }
                task = LXCommonDownloadTask.task(with: url, name: "task\(tasks.count)")
            }else {
                let link = "https://new.iskcd.com/20220408/1M9NVcM7/index.m3u8?time=\(Date.now.timeIntervalSince1970)"
                guard let url = URL(string: link) else { return }
                task = LXM3U8DownloadTask.task(with: url, name: "task\(tasks.count)")
            }
            tasks.append(task)
            downloader.download(task: task)
            self.table.reloadData()
        }else {
            let task = tasks[indexPath.item]
            if task.status != .suspend {
                downloader.suspend(task: task)
            }else {
                downloader.download(task: task)
            }
        }
        
    }
    
    
    
    
    
    
}
