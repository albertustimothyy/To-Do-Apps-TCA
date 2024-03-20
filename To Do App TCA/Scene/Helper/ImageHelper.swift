//
//  ImageHelper.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 20/03/24.
//

import Foundation
import SwiftUI

class ImageHelper {
    func decodeImage(photo: String) -> Image? {
        guard let dataDecoded: Data = Data(base64Encoded: photo, options: .ignoreUnknownCharacters) else { return Image("") }
        let decodedimage = UIImage(data: dataDecoded)
        return Image(uiImage: decodedimage ??  UIImage())
    }
    
    func loadImage(photo: UIImage?) -> Image?  {
        guard let inputImage = photo else { return Image("") }
        return Image(uiImage: inputImage)
    }
    
    func encodeImage(inputImage: UIImage?) -> String {
        if let inputData = inputImage?.pngData() {
            let strBase64 = inputData.base64EncodedString(options: .lineLength64Characters)
            return strBase64
        }
        return ""
    }
}
