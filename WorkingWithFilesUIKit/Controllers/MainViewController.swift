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
       let configuredbutton = configurebutton("Open a file")
        configuredbutton.addTarget(
            self,
            action: #selector(openFiles),
            for: .touchUpInside
        )
        return configuredbutton
    }()
    
    private lazy var gallaryButton: UIButton = {
       let configuredbutton = configurebutton("Open in app Gallery")
        configuredbutton.addTarget(
            self,
            action: #selector(openGallery),
            for: .touchUpInside
        )
        return configuredbutton
    }()
    
    // MARK: life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(openButton)
        view.addSubview(gallaryButton)
        view.backgroundColor = .darkGray
    }
    
    override func viewDidLayoutSubviews() {
        activateConstraints()
    }
    
    // MARK: private methods
    
    private func configurebutton(_ title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle( title, for: .normal)
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
            ),
            // Gallery button
            gallaryButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            gallaryButton.widthAnchor.constraint(
                equalToConstant: 150
            ),
            gallaryButton.topAnchor.constraint(
                equalTo: openButton.bottomAnchor, constant: 24
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
    
    @objc private func openGallery() {
        let gallery = GalleryViewController()
        navigationController?.pushViewController(
            gallery,
            animated: false
        )
    }
    
    private func renderView(url: URL?) {
        let playerController = AVPlayerViewController()
        guard let url = url else { return }
        playerController.player = AVPlayer(url: url)
        displaySheet(viewController: playerController)
    }
    
    private func  renderView(url: URL) {
        let pdf = PDFView()
        let document = PDFDocument(url: url)
        pdf.document = document
        displaySheet(view: pdf)
    }
    
    private func renderView(image: UIImage) {
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
        guard let url = urls.first else { return }
        
        switch url.mediaFile {
        case .empty:
            renderView(url: nil)
        case .image(let image):
            renderView(image: image)
        case .pdf(let url):
            renderView(url: url)
        case .vidoe(let url):
            renderView(url: url)
        }
    }
}

#Preview {
    MainViewController()
}
