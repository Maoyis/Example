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
        case zm = "直播"
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
        .common, .m3u8, .zm
    ]
    var tasks:[LXDownloadTask] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "下载"
        table.lx_tiling()
        self.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addAction(_:)))
        self.loadTasks()
    }
    @objc
    func addAction(_ sender:UIBarButtonItem)  {
        let page = AddDownloadPage.init()
        navigationController?.pushViewController(page, animated: true)
    }
    func insert(task:LXDownloadTask)  {
        tasks.append(task)
        self.table.reloadData()
    }
    func delete(index:Int)  {
        tasks.remove(at: index)
    }
    func loadTasks()  {
       
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
                var link = "https://n1.szjal.cn/20210411/2q5aIbup/index.m3u8?time=\(Date.now.timeIntervalSince1970)"
                if item == .zm {
                    link = "http://stream10.fjtv.net/cctv1/playlist.m3u8?_upt=fc595b6e1651233221"
                }
                guard let url = URL(string: link) else { return }
                task = LXM3U8DownloadTask.task(with: url, name: "task\(tasks.count)")
            }
            if let old = downloader.exist(task: task) {
                print("任务存在：\(old.name) -> \(task.name)")
            }else {
                downloader.download(task: task)
                insert(task: task)
            }
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
