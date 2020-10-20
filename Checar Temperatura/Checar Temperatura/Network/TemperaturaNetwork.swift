//
//  TemperaturaNetwork.swift
//  Checar Temperatura
//
//  Created by Wanderson Hipolito on 14/10/20.
//

import Foundation
import CoreLocation



protocol TemperatureManagerDelegate {
    func didUpdateTemperature(_ teamperatureManager: TemperaturaNetwork, temperatureModel: TemperaturaModel)
    func didFailWithError(_ error: Error)
    
    
    
    
}

struct TemperaturaNetwork {
    
    var delegate: TemperatureManagerDelegate?
    let sessionURL = "https://api.openweathermap.org/data/2.5/weather?"
    let API_KEY = "fd0ab5fdfbff69d278b9034b4f9e8fe5"
    
    func fecthLocationRequest(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(sessionURL)lat=\(latitude)&lon=\(longitude)&appid=\(API_KEY)&units=metric"
        performRequest(urlString)
    }
    
    
    func performRequest(_ urlString: String) {
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil{
                    
                }
                
                if let safeData = data{
                    if let temperature = parseJSON(safeData){
                        delegate?.didUpdateTemperature(self, temperatureModel: temperature)
                    }
            
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(_ tempData: Data) -> TemperaturaModel? {
        let decoder = JSONDecoder()
        do {
          let decodeData = try decoder.decode(TemperaturaData.self, from: tempData)
            let city = decodeData.name
            let temperature: Double = decodeData.main.temp
            
            let temperatureWeather = TemperaturaModel(city: city, temperature: temperature)
            print(temperatureWeather)
            return temperatureWeather
            
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
        
    }
    
    
}
