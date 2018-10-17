//
//  RecupereData.swift
//  FoodTracker
//
//  Created by Roses on 26/09/2018.
//  Copyright © 2018 Roses. All rights reserved.
//

import Foundation
import UIKit

class RecupereData : NSObject{
    
    //Valeurs à récupérer
    var depCode: Int?
    var depLib: String?
    var comLib: String?
    var insNom: String?
    var equEclairage: Int?
    var natureSolLib: String?
    var natureLibelle: String?
    var equGpsX: Double?
    var equGpsY: Double?
    
    //Constructeur vide
    override init()
    {
    }
    
    //Construire un objet avec les paramètres
    init(depCode: Int, depLib: String, comLib: String, insNom: String, equEclairage: Int,
         natureSolLib: String, natureLibelle: String, equGpsX: Double, equGpsY: Double) {
        
        self.depCode = depCode
        self.depLib = depLib
        self.comLib = comLib
        self.insNom = insNom
        self.equEclairage = equEclairage
        self.natureSolLib = natureSolLib
        self.natureLibelle = natureLibelle
        self.equGpsX = equGpsX
        self.equGpsY = equGpsY
    }
    
    //Retourne un objet Playground
    override var description: String {
        return "depCode: \(String(describing: depCode)), depLib: \(String(describing: depLib))"
        + "comLib: \(String(describing: comLib)), insNom: \(String(describing: insNom))"
        + "equEclairage: \(String(describing: equEclairage)), natureSolLib: \(String(describing: natureSolLib))"
        + "natureLibelle: \(String(describing: natureLibelle)), equGpsX: \(String(describing: equGpsX))"
        + "equGpsY: \(String(describing: equGpsY))"
        
    }
}
