//
//  GestureViewController.swift
//  WorkingWithFilesUIKit
//
//  Created by AMALITECH-PC-593 on 10/8/24.
//

import UIKit

class GestureViewController: UIViewController {
    
    // MARK: private variables
    
    var zoomDegree = ZoomDegree.none
    var zoomFactor = 1.5
    
    // MARK: private view variables
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "car")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.backgroundColor = .darkGray
        imageView.isUserInteractionEnabled = true
        addGesturesToImage()
       
    }
    
    override func viewDidLayoutSubviews() {
        setConstraints()
    }
    
    // MARK: public methods
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    // MARK: private methods
    
    private func addGesturesToImage() {
        let panRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePan(recognizer:))
        )
        let doubleTapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleZoom(_:))
        )
        doubleTapRecognizer.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapRecognizer)
        imageView.addGestureRecognizer(panRecognizer)
    }
    
    @objc private func handleZoom(_ recognizer: UITapGestureRecognizer) {
        
        switch zoomDegree {
        case .none:
            zoomDegree = .first
            zoomWithAnimation(1, 1)
        case .first:
            zoomDegree = .second
            zoomWithAnimation(1.5, 1.5)
        case .second:
            zoomDegree = .third
            zoomWithAnimation(2, 2)
        case .third:
            zoomDegree = .none
            zoomWithAnimation(1, 1)
        }
    }
    
    private func zoomWithAnimation(
        _ scaleX: CGFloat,
        _ scaleY: CGFloat
    ) {
        UIView.animate(withDuration: 0.25) {
            self.imageView.transform = CGAffineTransform(
                scaleX: scaleX,
                y: scaleY
            )
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            imageView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            imageView.widthAnchor.constraint(
                equalToConstant: 200
            ),
            imageView.heightAnchor.constraint(
                equalToConstant: 150
            )
        ])
    }
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        var x = imageView.center.x
        var y = imageView.center.y
        if checkTransitionStatus(recognizer.state) {
            let translation = recognizer.translation(in: view)
            x += translation.x
            y += translation.y
            imageView.center = CGPoint( x: x, y: y)
            recognizer.setTranslation(.zero, in: view)
        } 
    }
    
    private func checkTransitionStatus(
        _ state: UIGestureRecognizer.State
    ) -> Bool {
        if state == .began || state == .changed {
            return true
        }
        return false
    }
}

enum ZoomDegree {
    case none, first, second, third
}

#Preview {
    GestureViewController()
}
