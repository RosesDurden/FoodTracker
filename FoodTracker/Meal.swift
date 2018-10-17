//
//  Meal.swift
//  FoodTracker
//
//  Created by Roses on 01/07/2018.
//  Copyright © 2018 Roses. All rights reserved.
//

import UIKit
import os.log

//Cette classe est en charge de stocker et de charger toutes les propriétés du "Meal"
class Meal: NSObject, NSCoding {
    
    //MARK: Properties
    
    //Structure pour l'accès au repas PropertyKey.name par exemple
    struct PropertyKey{
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    //MARK: Chemin d'archives
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        
    }
    
    //MARK: NSCoding
    //Encode chaque propriété du repas and le stocke avec la clé correspondante
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    //Décodeur.
    //required --> cet initialiseur dit qu'il doit être implémenté dans chaque sous classe si la sous-classe définie son propre initaliseur
    //convenience --> Initaliseur secondaire, Doit appelé a initialiseur désigné dans la même classe
    //? --> C'est un initialiseur qui peut être défaillant, il retourne alors nil
    required convenience init?(coder aDecoder: NSCoder) {
        //Le nom est requis. Si on ne peut pas décoder le nom, l'initaliseur échoue
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else {
            os_log("Le nom de l'objet Repas n'a pas pu être décodé", log: OSLog.default, type: .debug)
            return nil
        }
        
        //La photo est un élement optionnel du repas, donc on peut le mettre en conditionnel
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        //Idem pour le rating. On utilise ici decodeInteger
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        //On doit appeler l'initialiseur désigné
        self.init(name: name, photo: photo, rating: rating)
    }
}
