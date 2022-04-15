//
//  MainCollectionViewController.swift
//  URLSession
//
//  Created by u on 11.04.2022.
//

import UIKit
import Alamofire

enum UserActions: String, CaseIterable {
    case loadImage = "Show tiger"
    case exampleOne = "Random jokes"
    case exampleTwo = "Random doggie"
    case post = "Post"
    case postModel = "Post model"
    case get = "Get"
    case alamofireGet = "Ala Get"
    case alamofirePost = "Ala Post"
}


class MainCollectionViewController: UICollectionViewController {
    
    let userActions = UserActions.allCases
    var jokeModel: Joke?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dogi" {
            guard let dogiVC = segue.destination as? DogiViewController else { return }
            dogiVC.fetch()
        }
        if segue.identifier == "postDogi" {
            guard let dogiVC = segue.destination as? DogiViewController else { return }
            dogiVC.alomorifePost()
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        userActions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.labelInCell.text = userActions[indexPath.item].rawValue
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .loadImage:
            performSegue(withIdentifier: "image", sender: nil)
        case .exampleOne:
            performSegue(withIdentifier: "joke", sender: nil)
        case .exampleTwo:
            performSegue(withIdentifier: "dogi", sender: nil)
        case .post:
            postRequest()
        case .postModel:
            postRequestModel()
        case .get:
            print("Not yet")
        case .alamofirePost:
            performSegue(withIdentifier: "postDogi", sender: nil)
        case .alamofireGet:
            alamofireGet()
        }
    }
}

extension MainCollectionViewController {
    
    private func postRequest() {
        let something = [
            "Name" : "Sergey",
            "Surname" : "Veretennikov",
            "Age" : 25
        ] as [String : Any]
        
        Network.postRequest(with: something, to: "https://jsonplaceholder.typicode.com/posts") { result in
            switch result{
            case .success(let something):
                print(something)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //Это типа откуда куда. Просто пробую. Не понимаю почему постится опшинал. Ну как бы понимаю что при сборке в нетворке кодируется именно через try?. Но можно ли сделать так чтобы туда отправлялся не опшинал объект? Пробовал его кастить там до нужного, но никак(
    private func postRequestModel() {
        Network.fetch(type: RandomDog.self, from: "https://dog.ceo/api/breeds/image/random") { result in
            switch result {
            case .success(let dog):
                Network.postRequestModel(with: dog, to: "https://jsonplaceholder.typicode.com/posts") { result in
                    switch result {
                    case .success(let dog):
                        print(dog)
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func alamofireGet() {
        Network.getDataAlamofire("https://v2.jokeapi.dev/joke/Any") { result in
            switch result {
            case .success(let joke):
                self.jokeModel = joke
            case .failure(let error):
                print(error)
            }
        }
        print(jokeModel as Any)
    }
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
}


