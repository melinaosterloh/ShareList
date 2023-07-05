//
//  AccountViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 21.06.23.
//

import UIKit
import Firebase
import FirebaseStorage
import Toast

// Protokoll, das dafür sorgt, dass die Tableview in SharelistViewController neu geladen wird, wenn eine neue Liste aufgewählt wird
protocol ReloadArticleDelegate: AnyObject {
    func reloadArticleTableView()
}

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var addListBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var listArray = [List]()
    var list: List?
    private var document: [DocumentSnapshot] = []
    weak var reloadArticleDelegate: ReloadArticleDelegate?
    var user = Auth.auth().currentUser
    var selectedListUID: String?
    var userID = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        loadDesign()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        getUserData()
    }
    
    // Funktion um Daten des Users im Profil anzuzeigen
    func getUserData() {
        let email = self.user?.email
        let userId = (self.user?.uid)!
        emailLabel.text = email
        let currentUser = self.db.collection("user").document(userId)
        currentUser.getDocument { (document, error) in
            if let document = document, document.exists {
                if let userName = document.data()?["name"] as? String {
                    self.nameLabel.text = userName
                }
                if let userImage = document.data()?["profileImageURL"] as? Data {
                    self.userImage.image = UIImage(data: userImage)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    // Table View Cell Höhe
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        let list = listArray[indexPath.row]

        listCell.textLabel?.text = "\(list.name)"
        
        listCell.tag = indexPath.row
        listCell.delegate = self
        listCell.indexPath = indexPath
        
        return listCell
    }
    
    // Ausgewählte Liste als aktuelle Liste
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntry = listArray[indexPath.row]
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.updateSelectedListID(selectedEntry.id) // newListID ist der Wert der neuen Listen-ID
        }
        // reload der aktuell ausgewählten Shoppinglist
        if let delegate = self.reloadArticleDelegate {
            delegate.reloadArticleTableView()
        }
    }
    
    func loadData() {
        // Vor dem Laden neuer Daten das listArray leeren
        listArray.removeAll()
        //if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           //let selectedListUID = appDelegate.selectedListID {
            let shoppingListsRef = self.db.collection("shoppinglist").whereField("owner", arrayContains: userID)
                shoppingListsRef.getDocuments { (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let snapshot = snapshot {
                            for document in snapshot.documents {
                                let data = document.data()
                                let name = data["name"] as? String ?? ""
                                let newList = List(id: document.documentID , name: name)
                                self.listArray.append(newList)
                                print(self.listArray)
                            }
                            self.listTableView.reloadData()
                        }

                    }
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
        newListViewController.reloadDelegate = self
        present(newListViewController, animated: true, completion: nil)
    }
    
    func loadDesign() {
        userImage.layer.cornerRadius = userImage.bounds.height / 2
        
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
    }
}

// Initialisierung der delete Buttons
extension AccountViewController: ListTableViewCellDelegate {

    func deleteButtonTapped(at indexPath: IndexPath) {
        let list = listArray[indexPath.row]
        deleteListFromDatabase(list)
        
        listArray.remove(at: indexPath.row)
        listTableView.deleteRows(at: [indexPath], with: .fade)
        listTableView.reloadData()
    }
    
    // Funktion zum löschen des Datenbankeintrages
    private func deleteListFromDatabase(_ list: List) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let selectedListID = appDelegate.selectedListID {
            self.db.collection("shoppinglist").document(selectedListID).delete() { error in
                if let error = error {
                    print("Error deleting article: \(error)")
                } else {
                    print("Liste gelöscht!")
                    //appDelegate.updateSelectedListID(<#String#>)
                    
                }
            }
        }
    }
}

// Extension für Delegation zur AccountViewController Klasse --> Reload TableView
extension AccountViewController: ReloadListDelegate {
    func reloadListTableView() {
        loadData()
    }
}

