//
//  File.swift
//  Example
//
//  Created by Qiaoxun Lei on 2022/5/1.
//

import Foundation
import LXLocalCache
import LXEncode
import LXDownloader
/*
 
 https://devstreaming-cdn.apple.com/videos/wwdc/2021/10143/8/02A20AB5-0C7F-4E9F-B252-75A25D1261ED/downloads/wwdc2021-10143_sd.mp4

 https://n1.szjal.cn/20210411/2q5aIbup/index.m3u8
 
 */

@objcMembers
class DownloadTask: NSObject, Codable {
    enum Status:Int, Codable {
        case download
        case finished
        case supend
    }
    var name:String = ""
    var link:String = ""
    var length:Int64 = 0
    var mimeType:String?
    var status:Status = .download
    var expired:Bool = false
    var createTime:Date?
    
    var url:URL {
        return URL(string: link)!
    }
    var isM3U8File:Bool {
        mimeType == "application/vnd.apple.mpegurl"
    }
    
    static func tasks(callback:(([DownloadTask])->Void)? = nil) {
        OperationQueue.main.addOperation {
            callback?(self.lxl_models())
        }
    }
    func downloadTask() -> LXDownloadTask {
        if isM3U8File {
            return LXM3U8DownloadTask.task(with: url, name: name)
        }else {
            return LXCommonDownloadTask.task(with: url, name: name)
        }
    }
    
    
    static func isVideo(mimeType:String?) -> Bool {
        guard let mime = mimeType else { return false }
        if mime.contains("video/") {
            return true
        }
        return false
    }
    static func isM3U8File(mimeType:String?) -> Bool {
        return mimeType == "application/vnd.apple.mpegurl"
    }
}



extension DownloadTask : LXLocalModel {
    func lxl_identifier() -> String {
        return link.lx_md5
    }
    
    func lxl_modelData() -> Data? {
        return try? JSONEncoder.lx_data(with: self, outFormat: .prettyPrinted, encryptKey: Self.description())
    }
    
    static func lxl_model(with data: Data) -> Self? {
        return try? JSONDecoder.lx_data(with: self, data: data, decryptKey: self.description())
    }
    
    
}
