//
//  DogiViewController.swift
//  URLSession
//
//  Created by u on 11.04.2022.
//

import UIKit

class DogiViewController: UIViewController {
    
    
    @IBOutlet var activitiIndicator: UIActivityIndicatorView!
    @IBOutlet var dogiImage: UIImageView!
    
    private var image: UIImage?
    private var success: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitiIndicator.startAnimating()
        activitiIndicator.hidesWhenStopped = true
        
    }
    
    func fetch() {
        Network.fetch(type: RandomDog.self, from: "https://dog.ceo/api/breeds/image/random") { result in
            switch result {
            case .success(let dog):
                guard let data =  URL(string: dog.message ?? "") else { return }
                guard let imageData = try? Data(contentsOf: data) else { return }
                self.dogiImage.image = UIImage(data: imageData)
                self.navigationItem.title = dog.status
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func alomorifePost() {
        
        let testDogi = RandomDog(message: "https://images.dog.ceo//breeds//terrier-australian//n02096294_7804.jpg", status: "success")
        
        Network.postDataAlamofire("https://jsonplaceholder.typicode.com/posts",
                                  data: testDogi) { result in
            switch result {
            case .success(let dog):
                guard let data = URL(string: dog.message ?? "") else { return }
                guard let imageData = try? Data(contentsOf: data) else { return }
                self.dogiImage.image = UIImage(data: imageData)
                self.navigationItem.title = dog.status
                self.activitiIndicator.startAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }

    
}
