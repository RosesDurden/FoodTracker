//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Roses on 04/06/2018.
//  Copyright © 2018 Roses. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    
    //MARK: Meal Class Tests
    
    func teastMealInitializationSucceeds(){
        //Note de zéro
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        //Note maximale positive
        let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    //Confirme que l'initialiseur du Meal return "nil" quand on lui passe une note negative ou un nom vide
    func testMealInitializationFails(){
        //Niveau négatif
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        //La note dépasse le maximum
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 0)
        XCTAssertNotNil(largeRatingMeal)
        
        //String vide
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
    }
    
}
