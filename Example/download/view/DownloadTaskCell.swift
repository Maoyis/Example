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
            self.textLabel?.text = task.name
            self.detailTextLabel?.text = "\(task.progress)"
        }
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
    func update(progress: Float) {
        OperationQueue.main.addOperation {[weak self] in
            self?.detailTextLabel?.text = String(format: "%.2f%%", progress*100)
        }
    }
    func update(status:LXDownloadTaskStatus) {
        OperationQueue.main.addOperation {[weak self] in
            if status == .suspend {
                self?.detailTextLabel?.text = "暂停"
            }
        }
    }
    
}
