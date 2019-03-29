//
//  ViewController.swift
//  FirebaseCloudStore
//
//  Created by SVOOMac on 3/18/19.
//  Copyright © 2019 varsha. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var author: UITextField!
    @IBOutlet weak var quotes: UITextField!
    
    @IBOutlet weak var quoteTextLabel: UILabel!
    
    var docref : DocumentReference!
    var quoteListener : ListenerRegistration!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        docref = Firestore.firestore().document("SampleData/Innovation")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quoteListener = docref.addSnapshotListener {(docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            let mydata = docSnapshot.data()
            let latestquote = mydata?["quotes"] as? String ?? ""
            let quoteauthor = mydata?["author"] as? String ?? ""
            self.quoteTextLabel.text = "\"\(latestquote)\" -- \(quoteauthor)"
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        quoteListener.remove()
    }

    @IBAction func submitBtnAction(_ sender: Any) {
        guard let authorText = author.text, !authorText.isEmpty else {return}
        guard let quotesText = quotes.text, !quotesText.isEmpty else {return}
        let data : [String : Any] = ["quotes": quotesText, "author" : authorText]
        docref.setData(data) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            else{
                self.author.text = ""
                self.quotes.text = ""
                print("Data has been saved")
            }
        }
    }
    
    @IBAction func fetchDataBtnAction(_ sender: Any) {
        
        docref.getDocument{(docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            let mydata = docSnapshot.data()
            let latestquote = mydata?["quotes"] as? String ?? ""
            let quoteauthor = mydata?["author"] as? String ?? ""
            self.quoteTextLabel.text = "\"\(latestquote)\" -- \(quoteauthor)"
        }
    }
}

