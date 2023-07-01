//
//  SharelistViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 18.06.23.
//

import UIKit
import Firebase

class SharelistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var articleListTableView: UITableView!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var basketBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    
    
    
    @IBOutlet var articlePopUpView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    var selectedListUID: String?
    
    var articleArray = [Article]()
    var article: Article?
    private var document: [DocumentSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.articleListTableView.delegate = self
        self.articleListTableView.dataSource = self
        
        loadDesign()
        loadData()
        

    }
    
    @IBAction func addArticleButton(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "goToAddArticle", sender: self)
    }
    
    // Button zum Öffnen des Profil Overlays
    @IBAction func menuButton(_ sender: UIButton) {
        let accountViewController = storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        accountViewController.modalPresentationStyle = .overCurrentContext
        accountViewController.modalTransitionStyle = .crossDissolve
        present(accountViewController, animated: true, completion: nil)
    }
    
    // Anzahl der zu erzeugenden Zellen
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArray.count
    }
    
    // Table View Cell Höhe
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // Bei Button Klick wird entsprechende Zelle des Indexes gelöscht und damit auch der Artikel in der Datenbank
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let article = articleArray[indexPath.row]
            deleteArticleFromDatabase(article)
            articleArray.remove(at: indexPath.row)
            articleListTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 
    // Zelle wird zugeordnet, Index hinzugefügt, infoButton der entsprechenden Zelle wird ausgelöst
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        let article = articleArray[indexPath.row]

        cell.textLabel?.text = "\(article.quantity + " " + article.productname)"
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 0.3
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.infoButton.tag = indexPath.row
        
        return cell
    }
    
    // Label des Pop ups werden den Artikeldateien zugeordnet (aus extra Klasse)
    func populatePopup(with article: Article) {
        productLabel.text = article.productname
        brandLabel.text = article.brand
        quantityLabel.text = article.quantity
        categoryLabel.text = article.cathegory
    }
    
    // Möglicherweise nicht benötigt
    @IBAction func deleteButton(_ sender: UIButton) {
    }
    
    
    // Pop up schließt
    @IBAction func checkButton(_ sender: UIButton) {
        animateOut(articleView: blurView)
        animateOut(articleView: articlePopUpView)
    }
    
    
    func loadData() {
        
        //initalize Database
        let db = Firestore.firestore()

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let selectedListID = appDelegate.selectedListID {
                print("In der Sharelist ist diese ID angekommen:", selectedListID)
                let shoppingListsRef = db.collection("shoppinglist").document(selectedListID).collection("article")
                shoppingListsRef.getDocuments { (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let snapshot = snapshot {
                            for document in snapshot.documents {
                                let data = document.data()
                                let id = data["id"] as? String ?? ""
                                let productname = data["productname"] as? String ?? ""
                                let brand = data["brand"] as? String ?? ""
                                let quantity = data["quantity"] as? String ?? ""
                                let cathegory = data["cathegory"] as? String ?? ""
                                let newArticle = Article(id: id, productname: productname, brand: brand, quantity: quantity, cathegory: cathegory)
                                self.articleArray.append(newArticle)
                            }
                            self.articleListTableView.reloadData()
                        }

                    }
                }
            } else {
                print("User ist null")
            }
    }

    func animateIn(articleView: UIView) {
        let backgroundView = self.view!
        
        // fügt subview zum Screen hinzu
        backgroundView.addSubview(articleView)
        
        // setzt view Skalierung auf 120%
        articleView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        articleView.alpha = 0
        articleView.center = backgroundView.center
        
        // Animationseffekt
        UIView.animate(withDuration: 0.3, animations: {
            articleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            articleView.alpha = 1
        })
    }
    
    func animateOut(articleView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            articleView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            articleView.alpha = 0
        }, completion: { (success:Bool) in
            articleView.removeFromSuperview()
        })
    }
    
    
    func loadDesign() {
        
        addBtn.layer.cornerRadius = addBtn.bounds.height / 2
        addBtn.layer.shadowRadius = 2
        addBtn.layer.shadowOpacity = 0.5
        addBtn.layer.shadowColor = UIColor.darkGray.cgColor
        addBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        basketBtn.layer.cornerRadius = basketBtn.bounds.height / 2
        basketBtn.layer.shadowRadius = 2
        basketBtn.layer.shadowOpacity = 0.5
        basketBtn.layer.shadowColor = UIColor.darkGray.cgColor
        basketBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        menuBtn.layer.cornerRadius = menuBtn.bounds.height / 2
        menuBtn.layer.shadowRadius = 2
        menuBtn.layer.shadowOpacity = 0.5
        menuBtn.layer.shadowColor = UIColor.darkGray.cgColor
        menuBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
    
        // blurView Größe ist gleich der Größe von der gesamten View
        blurView.bounds = self.view.bounds
        
        // width = 90%, height = 40%
        articlePopUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.3)
        articlePopUpView.layer.cornerRadius = 20
        
        productLabel.layer.cornerRadius = 10
        
        checkBtn.layer.cornerRadius = checkBtn.bounds.height / 2
        checkBtn.layer.shadowRadius = 2
        checkBtn.layer.shadowOpacity = 0.5
        checkBtn.layer.shadowColor = UIColor.darkGray.cgColor
        checkBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
}

// Initialisierung der info und delete Buttons
extension SharelistViewController: ArticleTableViewCellDelegate {
    func infoButtonTapped(at indexPath: IndexPath) {
        let selectedArticle = articleArray[indexPath.row]
        populatePopup(with: selectedArticle)
        animateIn(articleView: blurView)
        animateIn(articleView: articlePopUpView)
    }
    func deleteButtonTapped(at indexPath: IndexPath) {
        let article = articleArray[indexPath.row]
        deleteArticleFromDatabase(article)
        
        articleArray.remove(at: indexPath.row)
        articleListTableView.deleteRows(at: [indexPath], with: .fade)
        articleListTableView.reloadData()
        //articleListTableView.reloadRows(at: [indexPath], with: .fade)
        //UIView.animate(withDuration: 0.2, animations: {
        //    self.articleListTableView.cellForRow(at: indexPath)?.alpha = 0
        //}, completion: {_ in
        //self. ... // Aktualisiere die Tabelle, um den Index und die angezeigten Daten zu aktualisieren
        //})
    }
    
    // Funktion zum löschen des Datenbankeintrages
    private func deleteArticleFromDatabase(_ article: Article) {
            let db = Firestore.firestore()
            db.collection("shoppinglist").document(article.id).delete() { error in
                if let error = error {
                    print("Error deleting article: \(error)")
                } else {
                    print("Article deleted successfully!")
                }
            }
    }
}

