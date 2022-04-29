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
        
        let link = "http://stream10.fjtv.net/cctv1/playlist.m3u8?_upt=4f9c1b3b1651226109"
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
