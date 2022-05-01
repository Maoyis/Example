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
        
        let link = "https://devstreaming-cdn.apple.com/videos/wwdc/2021/10143/8/02A20AB5-0C7F-4E9F-B252-75A25D1261ED/downloads/wwdc2021-10143_sd.mp4"
        guard let url = URL(string: link) else { return }
        var reuqest = URLRequest.init(url: url)
        reuqest.httpMethod = "HEAD"
        URLSession.shared.downloadTask(with: reuqest) { url, response, error in
            if let resp  = response as? HTTPURLResponse {
                print(resp)
                print(resp.expectedContentLength)
                print(resp.mimeType ?? "")
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
