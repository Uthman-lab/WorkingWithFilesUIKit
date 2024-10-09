//
//  extensions.swift
//  WorkingWithFilesUIKit
//
//  Created by AMALITECH-PC-593 on 9/30/24.
//

import Foundation
import UIKit

extension URL {
    var mediaFile: MediaFile {
        switch self.pathExtension {
        case "jpg", "png":
                .image(parseImageData(url: self))
        case "mp4":
                .vidoe(url: self)
        case "pdf":
                .pdf(url: self)
        default:
                .empty
        }

    }
}

extension UIView {
    public static var spacerView: UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        view.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        return view
    }
}

enum MediaFile {
    case image(UIImage)
    case vidoe(url: URL)
    case pdf(url: URL)
    case empty
}

func parseImageData(url: URL) -> UIImage {
    let placeHolder = UIImage(ciImage: .empty())
    guard let data = try? Data(contentsOf: url) else {
        return placeHolder
    }
    return UIImage(data: data) ?? placeHolder
}
