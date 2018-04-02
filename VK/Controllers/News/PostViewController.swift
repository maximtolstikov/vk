//
//  PostViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 31/03/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var textPost: UITextView!
    
    let apiManager = ApiManager()
    
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
        
        let text = textPost.text
        guard text != nil else {
            print("Post text is nil!")
            return}
        apiManager.addPost(text: text!)
    }


}
