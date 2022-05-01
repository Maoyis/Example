//
//  EditCell.swift
//  Example
//
//  Created by Qiaoxun Lei on 2022/5/1.
//


import UIKit



protocol EditCellDelegate : NSObjectProtocol {
    func update(with value:Any?, in indexPath:IndexPath) -> Void
}

class EditCell: UITableViewCell {
    
    weak var delegate:EditCellDelegate?
    
    var value:Any?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func update(with value:Any?, delegate:EditCellDelegate? = nil)  {
        self.delegate = delegate
        self.value = value
    }
}

