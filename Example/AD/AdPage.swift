//
//  AdPage.swift
//  Example
//
//  Created by admin on 5/11/22.
//

import UIKit
import LXADKit

class AdPage: page {
    enum Item : String {
        case launch = "开屏广告"
        case banner = "横幅"
        case interstitial = "插页广告"
        case interstitialVideo = "插页视频"
        case rewarded = "激励"
        case rewardedInterstitial = "插页激励"
        case native = "原生"
        case nativeVideo = "原生视频"
    }
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
    var items:[Item] = [
        .launch,
        .interstitial, .interstitialVideo,
        .rewarded, .rewardedInterstitial,
        .native, .nativeVideo
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "广告"
        table.lx_tiling()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension AdPage : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = items[indexPath.item].rawValue
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        switch item {
        case .launch: AdMannager.default.launch()
        case .interstitial: AdMannager.default.interstitial()
        case .rewarded: AdMannager.default.rewarded()
        case .native: AdMannager.default.native()

        default:
            break
        }
        
    }
    
    
    
    
    
    
}
