//
//  PostViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 31/03/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit
import CoreLocation

class PostViewController: UIViewController {

    @IBOutlet weak var textPost: UITextView!
    
    let apiManager = ApiManager()
    var currentCoordinates: CLLocationCoordinate2D? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func viewDidAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(PostViewController.updateTapped(_:)))
    }
    
    @objc func updateTapped(_ button:UIBarButtonItem!){
        
        sendPost()
        performSegue(withIdentifier: "donePostSeque", sender: nil)
    }
    
    func sendPost() {
        
        var coordinatesInText: String = ""
        let text = textPost.text
        guard text != nil else {
            print("Post text is nil!")
            return}
        if ((currentCoordinates?.latitude) != nil) || (currentCoordinates?.longitude) != nil {
            coordinatesInText = "Coordinates: \(String(describing: currentCoordinates!.latitude)) \(String(describing: currentCoordinates!.longitude))"
        }
        let fullText = text! + "\n" + "\n" + coordinatesInText
        let textForURL = fullText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        apiManager.addPost(text: textForURL!)
    }


}
