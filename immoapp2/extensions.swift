
//
//  extensions.swift
//  immoapp2
//
//  Created by etudiant on 9/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation
import UIKit
extension UIScrollView {
    func scrollToBottom(animation animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}

extension UIImage {
    func resizeImage(_ image: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func data() -> Data {
        var imageData = UIImagePNGRepresentation(self)
        
        // Resize the image if it exceeds the 2MB API limit
        if (imageData?.count)! > 2097152 {
            let oldSize = self.size
            let newSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            let newImage = self.resizeImage(self, size: newSize)
            imageData = UIImageJPEGRepresentation(newImage, 0.7)
        }
        
        return imageData!
    }
    
    func base64EncodedString() -> String {
        let imageData = self.data()
        let stringData = imageData.base64EncodedString(options: .endLineWithCarriageReturn)
        return stringData
    }
}
