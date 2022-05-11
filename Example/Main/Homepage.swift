//
//  Homepage.swift
//  Example
//
//  Created by admin on 4/24/22.
//

import UIKit
//import LXLayoutKit



class Homepage: page {
    enum Item : String {
        case downloader = "lx-downloader"
        case ad
        case test

        case other
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
    
    let data:[[Item]] = [
        [.downloader, .ad],
        [.test]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        table.lx_tiling()
    }


}



extension Homepage : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let items = data[indexPath.section]
        cell.textLabel?.text = items[indexPath.item].rawValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let items = data[indexPath.section]
        let item = items[indexPath.row]
        var page:UIViewController!
        switch item {
        case .downloader: page = DownloadPage()
        case .test: page = TestPage()
        case .ad: page = AdPage()
        default:
            break
        }
        navigationController?.pushViewController(page, animated: true)
    }
    
    
    
    
    
    
}
