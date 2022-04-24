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
    
    let data:[Item] = [
        .downloader
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        table.lx_tiling()
    }


}



extension Homepage : UITableViewDelegate, UITableViewDataSource {
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
        var page:UIViewController!
        switch item {
        case .downloader: page = DownloadPage()
        default:
            break
        }
        navigationController?.pushViewController(page, animated: true)
    }
    
    
    
    
    
    
}
