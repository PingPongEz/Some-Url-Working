//
//  ImageViewController.swift
//  URLSession
//
//  Created by u on 11.04.2022.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIdentifier: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFit
        activityIdentifier.startAnimating()
        activityIdentifier.hidesWhenStopped = true
        fetchImage()
    }
    
    private func fetchImage() {
        Network.downloadImage { data in
            self.imageView.image = UIImage(data: data)
        }
        self.activityIdentifier.stopAnimating()
    }
}
