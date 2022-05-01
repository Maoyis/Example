//
//  File.swift
//  Example
//
//  Created by Qiaoxun Lei on 2022/5/1.
//

import Foundation



@objcMembers
class DownloadTask: NSObject {
    var name:String = ""
    var link:String = ""
    var length:Int64 = 0
    var mimeType:String?

    
    
    var isM3U8File:Bool {
        mimeType == "application/vnd.apple.mpegurl"
    }
}
