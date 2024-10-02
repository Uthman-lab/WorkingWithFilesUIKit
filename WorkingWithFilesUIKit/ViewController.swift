//
//  ViewController.swift
//  WorkingWithFilesUIKit
//
//  Created by AMALITECH-PC-593 on 9/30/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var openButton: UIButton!
    
    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBOutlet weak var mediaContent: UIView!
    
    var mediaFile: MediaFile = .empty
    
    var image: UIImageView {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }

    @IBAction func open(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.jpeg, .png])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overFullScreen
        documentPicker.allowsMultipleSelection = true
        present(documentPicker, animated: true)
    }
    
    @IBAction func close(_ sender: Any) {
        print("closed")
    }
    
}

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let  mediaFile = urls.first?.mediaFile {
            self.mediaFile = mediaFile
            viewDidLoad()
            print("open file \(urls.first)")
        }
    }
}

