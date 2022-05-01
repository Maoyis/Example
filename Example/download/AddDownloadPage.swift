//
//  AddDownloadPage.swift
//  Example
//
//  Created by Qiaoxun Lei on 2022/5/1.
//

import UIKit
import LXDownloader
import LXM3U8

class AddDownloadPage: page {
    enum Section {
        case task
        case otehr
    }
    enum Item : String {
        case link
        case name
        case wait
        case analyzing
        case expired
        case length
        case mimeType
        
        var name:String {
            switch self {
            case .name: return "文件名"
            case .link: return "网络连接"
            case .wait: return "等待输入"
            case .expired: return "连接已失效"
            case .analyzing : return "分析中...."
            case .mimeType : return "文件类型"
            case .length: return "预估大小"

            }
        }
    }
    var items:[[Item]] = [
        [.name, .link],
        [.wait]
    ]
    
    private var task:DownloadTask = .init()
    
    lazy var table: UITableView = {
        let table = UITableView.init(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        
        table.register(InputCell.self, forCellReuseIdentifier: InputCell.description())
        table.tableFooterView = UIView()
        view.addSubview(table)
        table.dataSource = self
        table.delegate   = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "创建任务"
        table.lx_tiling()
    }

}
extension AddDownloadPage {
    @objc
    func commit(_ sender:UIBarButtonItem)  {
        print(task.name, task.link)
        do {
            try LXDownloader.download(task: task)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    func value(of item:Item) -> Any? {
        return task.value(forKey: item.rawValue)
    }
    
}
extension AddDownloadPage : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = items[section]
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.selectionStyle = .none
        let item = items[indexPath.section][indexPath.item]
        let keyItems:[Item] = [.name, .link, .mimeType, .length]
        cell.textLabel?.textColor = UILabel().textColor
        if keyItems.contains(item) {
            let temp = value(of: item)
            if let value = temp as? String, !value.isEmpty {
                cell.textLabel?.text = value
            }else if let value = value(of: item) as? Int64 {
                cell.textLabel?.text = "\(value)"
            }else {
                cell.textLabel?.textColor = UIColor.placeholderText
                cell.textLabel?.text = item.name
            }

        }else {
            cell.textLabel?.text = item.name
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section][indexPath.item]
        if item == .name || item == .link {
            input(with: indexPath, item: item, value: nil)
        }
    }
    
    
    
    
    
    
}




extension AddDownloadPage : UITextFieldDelegate {
    
    func input(with indexPath:IndexPath, item:Item, value:Any?) {
        guard let cell = table.cellForRow(at: indexPath) else { return }
        var frame = cell.bounds
        frame.origin.x = cell.textLabel?.frame.origin.x ?? 0
        frame.size.width -= 2*frame.origin.x
        let field = UITextField.init(frame: frame)
        cell.addSubview(field)
        if let text = value {
            field.text = "\(text)"
        }
        field.placeholder = item.name
        field.font = cell.textLabel?.font
        field.backgroundColor = .systemBackground
        field.delegate = self
        field.tag = indexPath.section*1000 + indexPath.item
        switch item {
        case .link: field.keyboardType = .URL
        default:
            break
        }
        let toolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 40))
        let done = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(endEdit(_:)))
        let l = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [l, done]
        field.inputAccessoryView = toolbar;
        field.becomeFirstResponder()
    }
    
    @objc
    func endEdit(_ sender:UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let section = textField.tag/1000
        let row     = textField.tag%1000
        let item    = items[section][row]
        var value:Any?
        if item == .length {
            value = Int64(textField.text ?? "") ?? 0
        }else {
            value = textField.text
        }
        task.setValue(value, forKey: item.rawValue)
        guard item == .link else {
            return true
        }
        guard let url = URL(string: task.link) else { return false }
        if task.name.isEmpty {
            task.name = url.lastPathComponent
        }
        analyzing(url: url)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1, delay: 0, options: []) {
            textField.removeFromSuperview()
        } completion: { falg in
            self.table.reloadData()
        }
    }
}



extension AddDownloadPage {
    
    func analyzing(url:URL)  {
        self.navigationItem.rightBarButtonItem = nil
        defer {
            self.table.reloadData()
        }
        var reuqest = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        reuqest.httpMethod = "HEAD"
        self.items[1] = [.analyzing]
        URLSession.init(configuration: .default).downloadTask(with: reuqest) {[weak self] data, response, error in
            guard let self = self else { return }
            let code = (response as! HTTPURLResponse).statusCode
            if let eor = error {
                if code >= 400, code < 500 {
                    self.task.expired = true
                    self.items[1] = [.expired]
                }else {
                    fatalError(eor.localizedDescription)
                }
                return
            }
            self.task.mimeType = response?.mimeType
            if DownloadTask.isVideo(mimeType: response?.mimeType) {
                self.task.length   = response?.expectedContentLength ?? 0
            }else {
                let m3u8:M3U8File = .transform(with: url)
                if let content = try? String(contentsOf: url),
                   m3u8.analysis(content: content) {
                    if m3u8.playlist.count == 0,
                       let stream = m3u8.getStream(),
                       let streamURL = stream.URL,
                       let streamContent = try? String(contentsOf: streamURL),
                       m3u8.analysis(content: streamContent, of: stream),
                       let node = m3u8.playlist.first,
                       let nodeURL = URL(string: node.link)
                    {
                        let time = node.time
                        let length = self.length(of: nodeURL)
                        let duration = m3u8.duration
                        self.task.length = Int64(TimeInterval(length)/time*duration)
                    }
                }
            }
            OperationQueue.main.addOperation {
                if self.task.length > 0 {
                    self.items[1] = [.mimeType, .length]
                    self.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .done, target: self, action: #selector(self.commit(_:)))
                }else {
                    self.items[1] = [.expired]
                }
                self.table.reloadData()
            }
        }.resume()
    }
    
    
    func length(of url:URL) -> Int64 {
        var reuqest = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        reuqest.httpMethod = "HEAD"
        let semaphore =  DispatchSemaphore.init(value: 0)
        var length:Int64 = 0
        URLSession.shared.dataTask(with: reuqest) {temp, response, error in
            let code = (response as! HTTPURLResponse).statusCode
            if code == 200 {
                length = response?.expectedContentLength ?? 0
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return length
    }
}
