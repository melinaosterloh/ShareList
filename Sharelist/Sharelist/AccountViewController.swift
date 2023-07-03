//
//  AccountViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 21.06.23.
//

import UIKit
import Firebase
import Toast


class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var addListBtn: UIButton!
    
    let db = Firestore.firestore()
    var listArray = [List]()
    var list: List?
    private var document: [DocumentSnapshot] = []
    
    var selectedListUID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let selectedListID = appDelegate.selectedListID {
        }
        
        loadData()

        addListBtn.layer.cornerRadius = addListBtn.bounds.height / 2
        addListBtn.layer.shadowOpacity = 0.5
        addListBtn.layer.shadowColor = UIColor.darkGray.cgColor
        addListBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        closeBtn.layer.cornerRadius = closeBtn.bounds.height / 2
        closeBtn.layer.shadowRadius = 2
        closeBtn.layer.shadowOpacity = 0.5
        closeBtn.layer.shadowColor = UIColor.darkGray.cgColor
        closeBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        overlayView.layer.shadowRadius = 5
        overlayView.layer.shadowOpacity = 0.5
        overlayView.layer.shadowColor = UIColor.darkGray.cgColor
        overlayView.layer.shadowOffset = CGSize(width: 1, height: 1)

        let db = Firestore.firestore()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        if let user = Auth.auth().currentUser {
            let email = user.email
            emailLabel.text = email
        } else {
            emailLabel.text = "Benutzer ist nicht eingeloggt"
        }


    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath)
        let list = listArray[indexPath.row]

        listCell.textLabel?.text = "\(list.name)"
        
        listCell.tag = indexPath.row
        // listCell.delegate = self
        // listCell.indexPath = indexPath
        
        return listCell
    }
    
    func loadData() {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let selectedListID = appDelegate.selectedListID {
                print("In der Sharelist ist diese ID angekommen:", selectedListID)
                let shoppingListsRef = db.collection("shoppinglist").document(selectedListID).collection("name")
                shoppingListsRef.getDocuments { (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let snapshot = snapshot {
                            for document in snapshot.documents {
                                let data = document.data()
                                let id = data["id"] as? String ?? ""
                                let name = data["name"] as? String ?? ""
                                let newList = List(id: id, name: name)
                                self.listArray.append(newList)
                            }
                            self.listTableView.reloadData()
                        }

                    }
                }
            } else {
                print("User ist null")
            }
    }

    
    @IBAction func logoutButton(_ sender: UIButton) {
        let navigationViewController = storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as! NavigationViewController
        navigationViewController.modalPresentationStyle = .overCurrentContext
        navigationViewController.modalTransitionStyle = .crossDissolve
        present(navigationViewController, animated: true, completion: nil)
        
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
    
    @IBAction func addListButton(_ sender: UIButton) {
        let newListViewController = storyboard?.instantiateViewController(withIdentifier: "NewListViewController") as! NewListViewController
        newListViewController.modalPresentationStyle = .overCurrentContext
        newListViewController.modalTransitionStyle = .crossDissolve
        present(newListViewController, animated: true, completion: nil)
    }
    
    


}
