//
//  Downloader.swift
//  Example
//
//  Created by Qiaoxun Lei on 2022/5/1.
//

import Foundation
import LXDownloader



extension LXDownloader {
    static func download(task:DownloadTask) throws {
        try task.lxl_cache()
        if task.isM3U8File {
            
        }
    }
}
