//
//  JoinCallDataSaving.swift
//  CallEntry
//
//  Created by Newage Software and Solutions on 25/12/19.
//  Copyright © 2019 Gowtham. All rights reserved.
//

import UIKit

struct JoinCallDataSaving: Codable {
   
    var nameSave: String!
    var descriptSave: String!
    var codeSave: String!
    
    init(name: String, desc: String, code: String) {
        self.nameSave = name
        self.descriptSave = desc
        self.codeSave = code
    }
}
