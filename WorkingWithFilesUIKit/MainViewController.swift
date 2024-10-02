//
//  MainViewController.swift
//  WorkingWithFilesUIKit
//
//  Created by AMALITECH-PC-593 on 10/1/24.
//

import UIKit
import AVKit
import PDFKit

class MainViewController:  UIViewController {
    
    // MARK: views
    
    private lazy var openButton: UIButton = {
       let configuredbutton = configurebutton()
        configuredbutton.addTarget(
            self,
            action: #selector(openFiles),
            for: .touchUpInside
        )
        return configuredbutton
    }()
    
    // MARK: life cycle methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(openButton)
        view.backgroundColor = .darkGray
    }
    
    override func viewDidLayoutSubviews() {
        activateConstraints()
    }
    
    // MARK: private methods
    
    private func configurebutton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Open a file", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            openButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            openButton.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            openButton.widthAnchor.constraint(
                equalToConstant: 100
            )
        ])
    }
    
    @objc private func openFiles(){
        let picker = UIDocumentPickerViewController(
            forOpeningContentTypes: [
                .png,
                .jpeg,
                .video,
                .mpeg,
                .movie,
                .pdf
            ]
        )
        picker.delegate = self
        present(picker, animated: false)
    }
    
    private func renderAudio(url: URL) {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            
        }
    }
    private func renderView(url: URL) {
        let playerController = AVPlayerViewController()
        playerController.player = AVPlayer(url: url)
        displaySheet(viewController: playerController)
    }
    
    private func  renderPDF(url: URL) {
        let pdf = PDFView()
        let document = PDFDocument(url: url)
        pdf.document = document
        displaySheet(view: pdf)
    }
    
    private func renderImage(image: UIImage) {
        let uiImgeView = UIImageView()
        uiImgeView.image = image
        uiImgeView.sizeToFit()
        uiImgeView.contentMode = .scaleAspectFill
        displaySheet(view: uiImgeView)
    }
    
    private func displaySheet(view: UIView) {
        let viewController = UIViewController()
        viewController.view = view
        present(viewController, animated: false)
    }
    
    private func displaySheet(viewController: UIViewController) {
        present(viewController, animated: false)
    }
}

extension MainViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return}
        
        switch url.mediaFile {
        case .empty:
            UIView()
        case .image(let image):
            renderImage(image: image)
        case .pdf(let url):
            renderPDF(url: url)
        case .vidoe(let url):
            renderView(url: url)
        }
    }
}

#Preview {
    MainViewController()
}
