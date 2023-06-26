//
//  AccountViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 21.06.23.
//

import UIKit
import Firebase
import Toast


class AccountViewController: UIViewController {
    
    
    

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var overlayView: UIView!

    
    //var listArray = [Article]()
    //var article: Article?
    //private var document: [DocumentSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        overlayView.layer.shadowRadius = 5
        overlayView.layer.shadowOpacity = 0.5
        overlayView.layer.shadowColor = UIColor.darkGray.cgColor
        overlayView.layer.shadowOffset = CGSize(width: 1, height: 1)

        if let user = Auth.auth().currentUser {
            let email = user.email
            emailLabel.text = email
        } else {
            emailLabel.text = "Benutzer ist nicht eingeloggt"
        }

     //   self.listTableView.delegate = self
     //  self.listTableView.dataSource = self
        
    //    loadData()
    }
    
    //func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //    return listArray.count
    //}
    
    //func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //    let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath)
        //let article = articleArray[indexPath.row]

        //cell.textLabel?.text = "\(article.quantity + " " + article.productname)"
        
        //cell.layer.cornerRadius = 10
        //cell.layer.borderColor = UIColor.darkGray.cgColor
        //cell.layer.borderWidth = 0.3
        
        //cell.delegate = self
        //cell.indexPath = indexPath
        //cell.infoButton.tag = indexPath.row
        
    //    return cell
    //}
    
   // func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //      return 50  // Set the desired height for each cell
   // }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainViewController.modalPresentationStyle = .overCurrentContext
        mainViewController.modalTransitionStyle = .crossDissolve
        present(mainViewController, animated: true, completion: nil)
        
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
        } catch {
            print("User Logout failed!")
        }
        self.performSegue(withIdentifier: "goToLoginScreen", sender: self)
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    
    /* func loadData() {
        
        //initalize Database
        let db = Firestore.firestore()
        
        let userRef = db.collection("user").document("3MCeDNUzyRtZ5TYnkmqM")

        userRef.collection("shoppinglist").getDocuments() { (snapshot, error) in
            if let error = error {
                print("error")
            } else {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        
                        
                    }
                    self.listTableView.reloadData()
                }
            }
        }
    } */
    

}
