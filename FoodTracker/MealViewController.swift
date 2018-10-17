//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Roses on 04/06/2018.
//  Copyright © 2018 Roses. All rights reserved.
//

import UIKit
import os.log

//Ajouter EnvoieDataProtocol après UITableViewDelegate et UITableViewDataSource avant 
class MealViewController: UIViewController, UITextFieldDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate {
    
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return 1;
    }
    
    func itemsDownloaded(items: NSArray) {
    
    }*/
    
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     Cette valeur sera passe soit pas 'MealtableViewController' dans la méthode
     'prepare(for:sender:)'
     soit construite comme l'ajout d'un nouveau repas
     */
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gère l'input du champ texte de l'utilisateur à traver les appels
        nameTextField.delegate = self
        
        //Contrôles sur le repas qu'on récupère du segue
        if let meal = meal{
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // Active le bouton seulement si un texte est entré
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    // Fonction appelée quand on a fini d'éditer
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        //Change le texte dans la Navigation Bar
        navigationItem.title = textField.text
    }
    
    // Fonction appelée quand on commence à éditer ou que le clavier est ouvert
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Désactiver le bouton pendant l'édition de cette vue
        saveButton.isEnabled = false
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //En fonction du style de présentation (présentation modal ou push), cette vue aura besoin d'être cancelé de deux manières.
        //Est-ce que la scène est en mode NavigationController?
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
            //Else : si l'utilisateur est en mode édition d'un repas existant
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else{
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    // Cette méthode permet de configurer la vue d'un contrôleur avant qu'elle ne soit affichée
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        // Cette ligne ne fait rien mais c'est une très bonne habitude d'appeler super.prepare quand on override le prepare(for:sender:)
        // Ca permet de ne pas l'oublier l'appelle dans une sous-classe dans une autre classe
        super.prepare(for: segue, sender: sender)
        // Configure la vue de destination quand le bouton 'Enregistrer' est sélectionné
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("Le bouton pour enregistrer n'a pas été appuyé, annulation en cours", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? "" // Le '??' permet de retourner soit la valeur si elle est présente, soit une valeur par défaut, ici --> ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // Paramètre le menu pour être passer à la MealTableViewController après le retour du segue
        meal = Meal(name: name, photo: photo, rating: rating)
    }

    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //Hide the keyboard when the user tap the image view
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        //Only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState(){
        // Désactive le bouton 'Enregistrer' si le champ text est vide
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}
