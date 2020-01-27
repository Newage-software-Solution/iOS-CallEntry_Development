//
//  BaseDataHandler.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class BaseDataHandler: NSObject {

    func jsonStringToJSONObject(jsonString: String) -> Any? {
        
        if let data = jsonString.data(using: String.Encoding.utf8)
        {
            do
            {
                return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            }
            catch let myJSONError
            {
                print(myJSONError)
            }
            
        }
        
        return nil
    }
}
