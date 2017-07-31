//
//  UploadedMedia.swift
//
//
//  Created by Juliana Strawn on 5/2/17.
//
//

import UIKit

class UploadedMedia: NSObject {
    
    var fileURL:String
    var type:String
    var uuid:String?
    var UIImage:UIImage?
    var videoFile:URL?
    
    
    init(url:String, type:String) {
        self.fileURL = url
        self.type = type
    }
}
