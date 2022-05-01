//
//  InputCell.swift
//  Example
//
//  Created by Qiaoxun Lei on 2022/5/1.
//

import UIKit

class InputCell: EditCell {
    
    override var value: Any? {
        didSet{
            input.text = value as? String
        }
    }
    
    
    
    lazy var input: UITextField = {
        let input = UITextField.init()
        input.delegate = self
        contentView.addSubview(input)
        return input
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.input.frame = self.bounds
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



extension InputCell : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let table = self.superview as? UITableView else {
            return
        }
        guard let indexPath = table.indexPath(for: self) else {
            return
        }
        delegate?.update(with: textField.text, in: indexPath)
    }
}
