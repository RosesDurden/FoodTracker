//
//  LoginViewController.swift
//  FoodTracker
//
//  Created by Roses on 14/10/2018.
//  Copyright © 2018 Roses. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    if error != nil
    {
        //S'il y a une erreur
        //self.lblStatut.text = "Erreur lors de la connexion"
    }
    else if result.isCancelled{
        //Si l'utilisateur annule la connexion
        //self.lblStatut.text = "Connexion annulée"
    }
    else
    {
        //Connexion réussie
        //self.lblStatut.text = "Utilisateur connecté"
    }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //self.lblStatut.text = "Utilisateur déconnecté."
    }
    
    @IBOutlet weak var lblStatut: UILabel!
    
    override func viewDidLoad() {
    }
}
