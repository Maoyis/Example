////
////  ViewController.swift
////  Example
////
////  Created by admin on 4/6/22.
////
//
//import UIKit
//import SafariServices
//import LXLayoutKit
//import WebKit
//import LXCommonKit
//
//
//
//class ViewController: UIViewController {
//
//    @IBOutlet weak var web: WKWebView!
//    lazy var table: UITableView = {
//        let table = UITableView.init(frame: .zero, style: .insetGrouped)
//        view.addSubview(table)
//        return table
//    }()
//
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        NotificationCenter.system(observer: self, item: .screenshot, selector: #selector(screenshotHandle(_:)))
//        let url = URL(string: "https://www.baidu.com")!
//        let req = URLRequest.init(url: url)
//        web.load(req)
//    }
//
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        if view.subviews.count > 1 {
//            view.subviews.last?.removeFromSuperview()
//        }else {
//
//        }
//    }
//
//    @objc
//    func screenshotHandle(_ noti:Notification)  {
//        snapshot()
//    }
//    func snapshot2() {
//        let background = UIView.init(frame: view.bounds)
//        background.backgroundColor = .black
//        let image = self.web.snapshot(size: web.scrollView.contentSize, webview: true)
//        try! image?.pngData()?.write(to: URL(fileURLWithPath: "/Users/mitoplay/Desktop/web.png"))
//    }
//    func snapshot() {
//        let background = UIView.init(frame: view.bounds)
//        background.backgroundColor = .black
//        if let snapshot = self.web.scrollView.snapshotView(afterScreenUpdates: true) {
//            snapshot.frame = web.scrollView.bounds.lx_multi(0.5)
//            snapshot.center = background.center
//            background.addSubview(snapshot)
//        }else {
//            background.backgroundColor = .red
//        }
//        view.addSubview(background)
//    }
//}
//
//extension ViewController {
//
//
//}
