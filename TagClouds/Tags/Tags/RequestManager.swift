//
//  RequestManager.swift
//  TagCloud
//
//  Created by Никита Комаров on 01.04.2022.
//

import Alamofire

// MARK: - Обработчик запроса к серверу
class RequestManager {
    
    var requested: Drinks?
    
    func getDrinks(completion: @escaping () -> ()) {
        
        let request = AF.request("https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic")
        
        request.responseDecodable(of: Drinks.self) { response in
            if case .success = response.result {
                self.requested = response.value
                completion()
            }
        }
    }
    
}
