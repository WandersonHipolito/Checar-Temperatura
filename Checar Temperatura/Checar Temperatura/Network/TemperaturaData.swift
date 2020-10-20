//
//  TemperaturaData.swift
//  Checar Temperatura
//
//  Created by Wanderson Hipolito on 14/10/20.
//

import Foundation


struct TemperaturaData: Codable {
    let name: String
    let main : Main
    
}

struct Main: Codable {
    let temp: Double
}
