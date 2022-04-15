//
//  JokeViewController.swift
//  URLSession
//
//  Created by u on 13.04.2022.
//

import UIKit

enum ButtonCase: String {
    
    case noJoke = "Press for joke"
    case setup = "Press for punch"
    case punch = "Next joke?"
    
}

class JokeViewController: UIViewController {
    
    @IBOutlet var setupLabel: UILabel!
    @IBOutlet var punchLabel: UILabel!
    
    var joke: Joke?
    
    private let jokeUrl = "https://v2.jokeapi.dev/joke/Any"
    private var jokeStatus: ButtonCase?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        joke = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupLabel.isHidden = true
        punchLabel.isHidden = true
        
        jokeStatus = .noJoke
        
        serverJoking()
        
    }
    
    @IBAction func jokeManipulatorPressed(_ sender: UIButton) {
        sender.pulse()
        
        switch jokeStatus {
        case .noJoke:
            
            if joke?.setup == nil {
                showSTOPSPAMINGPLEASEALERT()
                break
            }
            
            setupLabel.text = joke?.setup
            setupLabel.isHidden = false
            
            if joke?.delivery == nil {
                jokeStatus = .punch
            } else {
                jokeStatus = .setup
            }
            
        case .setup:
            
            if joke?.delivery == nil {
                showSTOPSPAMINGPLEASEALERT()
                break
            }
            
            punchLabel.text = joke?.delivery
            punchLabel.isHidden = false
            
            jokeStatus = .punch
            
        case .punch:
            
            punchLabel.isHidden = true
            setupLabel.isHidden = true
            
            jokeStatus = .noJoke
            joke = nil
            serverJoking()
            
            
        default: print("Fatal")
        }
        
        sender.setTitle(jokeStatus?.rawValue, for: .normal)
    }
}

extension JokeViewController {
    private func serverJoking() {
        Network.fetch(type: Joke.self, from: jokeUrl) { result in
            switch result {
            case .success(let joke):
                self.joke = joke
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension UIButton {
    func pulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.95
        pulse.toValue = 1
        layer.add(pulse, forKey: nil)
    }
}

extension JokeViewController {
    private func showSTOPSPAMINGPLEASEALERT() {
        let alert = UIAlertController(title: "STOPSPAMINGPLEASE", message: "WAIT", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.serverJoking()
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
