//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Roses on 02/07/2018.
//  Copyright © 2018 Roses. All rights reserved.
//

import UIKit
import os.log
import CoreData
import FBSDKLoginKit

class MealTableViewController: UITableViewController, FBSDKLoginButtonDelegate {
    //MARK: Properties
    //@IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblStatut: UILabel!
    
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let btnFBLogin = FBSDKLoginButton()
        //btnFBLogin.center = self.view.center
        btnFBLogin.readPermissions = ["public_profile", "email", "user_friends"]
        btnFBLogin.delegate = self
        /*btnFBLogin.center = CGPoint(x: tableView.bounds.size.width / 2,
                                    y: tableView.bounds.size.height - buttonSize.height / 2 - bottomMargin)*/
        
        //btnFBLogin.center = tableView.viewWithTag(19).center
        let screenSize:CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height //real screen height
        //let's suppose we want to have 10 points bottom margin
        let newCenterY = screenHeight - btnFBLogin.frame.height - 10
        let newCenter = CGPoint(x: view.center.x, y: newCenterY)
        btnFBLogin.center = newCenter
        self.view.addSubview(btnFBLogin)
        //tableView.viewWithTag(19)?.addSubview(btnFBLogin)
        
        if(FBSDKAccessToken.current() == nil)
        {
            self.lblStatut.text = "Non connecté"
        }
        else{
            self.lblStatut.text = "Connecté"
            //Utiliser le bouton d'édition fourni par le table view controller
            navigationItem.leftBarButtonItem = editButtonItem
            self.navigationItem.leftBarButtonItem!.title = "Modifier"
            
            //Charger les repas enregistrés, autrement, charger les données. Si la méthode loadMeals() retourne bien un array de meals, la condition if va être vraie. On va alors affecté les meals à la nouvelle variable savedMeals
            if let savedMeals = loadMeals(){
                meals += savedMeals
            } else{
                //Charger les données
                loadSampleMeals()
            }
            
            // Load the sample data.
            loadSampleMeals()
            loadSampleMeals()
            loadSampleMeals()
            loadSampleMeals()
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil
        {
            //S'il y a une erreur
            self.lblStatut.text = "Erreur lors de la connexion"
        }
        else if result.isCancelled{
            //Si l'utilisateur annule la connexion
            self.lblStatut.text = "Connexion annulée"
        }
        else
        {
            //Connexion réussie
            self.lblStatut.text = "Utilisateur connecté"
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.lblStatut.text = "Utilisateur déconnecté."
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if(self.isEditing)
        {
            self.editButtonItem.title = "Annuler"
        }else{
            self.editButtonItem.title = "Modifier"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < meals.count
        {
            // Table view cells are reused and should be dequeued using a cell identifier.
            let cellIdentifier = "MealTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell  else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
            }
            
            // Fetches the appropriate meal for the data source layout.
            let meal = meals[indexPath.row]
            
            cell.nameLabel.text = meal.name
            cell.photoImageView.image = meal.photo
            cell.ratingControl.rating = meal.rating
            
            return cell
        }
        else
        {
            let buttonLoginCell = self.tableView.dequeueReusableCell(withIdentifier: "cellLoginButton")
            return buttonLoginCell!
        }
    }
    

    
    // Override pour l'édition conditionnelle de la table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override pour l'édition de la table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Supprime la ligne de la table de données
            meals.remove(at: indexPath.row)
            //Enregistrement après suppression
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        //Si l'identifier est à nil, on lui donne la valeur "" à la place;
        switch(segue.identifier ?? ""){
        //Si l'utilisateur ajoute un nouveau plat, pas besoin de renvoyer les valeurs à l'autre scène, juste envoyer un message LOG en cas de débug,
        //Ca peut être utile
        case "AddItem":
            os_log("Adding a new meal.", log:OSLog.default, type: .debug)
        case "ShowDetail":
            //On récupère la vue de destination
            guard let mealDetailViewController = segue.destination as? MealViewController else{
                    fatalError("Destination innatendue : \(segue.destination)")
                }
            //On récupère la cellulle concernée
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            //On récupère l'index du repas dans la liste
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("La cellule choisie ne peut pas être affichée.")
            }
            //On récupère toutes les données du repas
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
 
    
    //MARK: Actions
    
    //Méthode appelée quand l'utilisateur appuie sur le bouton "Enregistrer"
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        // On vérifie la source qu'on reçoit, si c'est du type MealViewController, on définit la variable meal
        // Comme la variable 'meal' qu'on reçoit
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal{
            
            //Vérifie si la ligne est sélectionnée dans la vue. Si oui, ça veut dire qu'un utilisateur a cliqué sur la ligne
            //afin de modifier les valeurs.
            if let selectedIndexpath = tableView.indexPathForSelectedRow{
                //Mise à jour du repas
                meals[selectedIndexpath.row] = meal
                tableView.reloadRows(at: [selectedIndexpath], with: .none)
            }
            //le else est utilisé dans le cas où on change de vue sans avoir appuyé sur une ligne de la table
            //cela signifie que c'est le bouton "+" qui a été sélectionné
            else{
                //Enregister les repas.
                saveMeals()
                
                //Ajoute un nouveau menu
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                
                //Ajoute le nouveau menu à la liste des menus déjà présents
                meals.append(meal)
                
                //Ajoute le nouveau menu à la tableView
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    //MARK: Private Methods
    //Permet de charger des données dans l'application
    private func loadSampleMeals() {
        
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }
        
        meals += [meal1, meal2, meal3]
    }
    
    private func saveMeals(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave{
            os_log("Les repas sont bien enregistrés.", log: OSLog.default, type: .debug)
        }else{
            os_log("Les repas n'ont pas pu être enregistrés...", log: OSLog.default, type: .error)
        }
    }
    
    //Charger la liste des repas qu'on récupère dans le fichier Meal.ArchiveURL.path
    private func loadMeals() -> [Meal]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    
    func readDataFromFile(file:String) -> String!{
        guard let filePath = Bundle.main.path(forResource: file, ofType: "txt")
            else{
                return nil
        }
        do{
            let contents = try String(contentsOfFile: filePath)
            return contents
        } catch{
            print("Erreur lors de la lecture du fichier \(filePath) ")
            return nil
        }
    }
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
}
