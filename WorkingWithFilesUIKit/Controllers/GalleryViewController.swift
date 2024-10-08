//
//  GalleryViewController.swift
//  WorkingWithFilesUIKit
//
//  Created by AMALITECH-PC-593 on 10/7/24.
//

import UIKit
import Photos

class GalleryViewController:  UIViewController {
    
    // MARK: private variables
    
    private lazy var collectionView: UICollectionView = {
        let collection = configureCollection()
        requestPermission()
        return collection
    }()
    
    private var images: [UIImage] = []
    
    // MARK: life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .darkGray 
        view.addSubview(collectionView)
    }
    
    // MARK: private methods
    
    private func requestPermission() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                self?.fetchPhotos()
            } else {
                self?.requestPermission()
            }
        }
    }
    
    private func configureCollection() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        
        let itemsPerRow: CGFloat = 3
        let padding: CGFloat = 10
        let totalPadding = padding * (itemsPerRow + 1)
        let itemWidth = (view.frame.width - totalPadding) / itemsPerRow
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        
        let collectionView = UICollectionView(
            frame: view.frame,
            collectionViewLayout: layout
        )
        
        collectionView.contentInset = .init(
            top: padding,
            left: padding,
            bottom: padding,
            right: padding
        )
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        return collectionView
    }

    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(
            with: .image,
            options: fetchOptions
        )
        
        let imageManager = PHCachingImageManager()
        let targetSize = CGSize(width: 100, height: 100)
        
        fetchResult.enumerateObjects { (asset, index, stop) in
            imageManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFit,
                options: nil
            ) { (image, _) in
                if let image = image {
                    self.images.append(image)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        )
        let imageContent = configureImage(
            image: images[indexPath.row],
            cell: cell
        )
        cell.contentView.addSubview(imageContent)
        return cell
    }
    
    private func configureImage(
        image: UIImage,
        cell: UICollectionViewCell
    ) -> UIImageView {
        let view = UIImageView(
            image: image
        )
        view.frame = cell.contentView.frame
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let imageSheet = GestureViewController()
        imageSheet.setImage(images[indexPath.row])
        present(imageSheet, animated: true)
    }
}

#Preview {
    GalleryViewController()
}
