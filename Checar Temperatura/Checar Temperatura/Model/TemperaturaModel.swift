//
//  TemperaturaModel.swift
//  Checar Temperatura
//
//  Created by Wanderson Hipolito on 15/10/20.
//

import Foundation

struct TemperaturaModel {
    let city: String
    let temperature: Double
    
    
    var temperaturaString: String{
        return String(format: "%.1f", temperature)
    }
}
