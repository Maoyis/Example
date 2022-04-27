//
//  DownloadTaskCell.swift
//  Example
//
//  Created by admin on 4/25/22.
//

import UIKit
import LXDownloader

class DownloadTaskCell: UITableViewCell {

    var task:LXDownloadTask! {
        didSet {
            updateUI()
        }
    }
    func updateUI()  {
        var label = task.name
        var detail = String(format: "%.2f%%", task.progress*100)
        switch task.status {
        case .finished: label += ""; detail = "已完成"
        case .downloading: label += "-下载中..."
        case .suspend: label += "-暂停"
        default:
            label += "-等待中"
            break
        }
        self.textLabel?.text = label
        self.detailTextLabel?.text = detail
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension DownloadTaskCell : LXDownloadTaskDelegate {
    func update(length: Int64, downloaded: Int64, total: Int64) {
        OperationQueue.main.addOperation {[weak self] in
            self?.updateUI()
        }
    }
    func update(status:LXDownloadTaskStatus) {
        OperationQueue.main.addOperation {[weak self] in
            self?.updateUI()
        }
    }
    
}
