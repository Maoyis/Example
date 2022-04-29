//
//  TestPage.swift
//  Example
//
//  Created by admin on 4/29/22.
//

import UIKit

class TestPage: page {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "测试页"
        
        let u1 = URL(string: "t://x.y.z/aa/bb/cc.z")
        let u2 = URL(string: "//x.y.z/aa/bb/cc.z")
        let u3 = URL(string: "x.y.z/aa/bb/cc.z")
        let u4 = URL(string: "bb/cc.z")
        let u5 = URL(string: "../../cc.z?_pi=12123.3")

        let link = "http://stream10.fjtv.net/cctv1/playlist.m3u8?_upt=2088d1e71651211885"
        let link2 = "http://stream10.fjtv.net/cctv1/hd/live.m3u8?_upt=42a172321651222569"
        let link3 = "http://stream10.fjtv.net/cctv1_hd/1651210373/1651211961947.ts?_upt=a8e3f9201651222761"
        guard let url = URL(string: link) else { return }
        let reuqest = URLRequest.init(url: url)
        URLSession.shared.downloadTask(with: reuqest) { url, response, error in
            if let resp  = response as? HTTPURLResponse {
                print(resp)
            }
        }.resume()
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
