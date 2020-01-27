////
////  SwiftObjectMapper.swift
////  Explore4D
////
////  Created by Jeyaraj on 27/04/15.
////  Copyright (c) 2016 hakuna. All rights reserved.
////
//
import UIKit

class SwiftObjectMapper: NSObject {
    
}

extension String {
    
    func capitalizingFirstLetter() -> String {
        
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        
        return first + other
        
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


protocol Reflectable {
    func propertys()->[String]
}

extension Reflectable
{
    func propertys() -> [String] {
        
        var s = [String]()
        
        for c in Mirror(reflecting: self).children {
            
            if let name = c.label {
                
                s.append(name)
                
            }
            
        }
        
        return s
    }
}

extension NSObject: Reflectable {
    
}

class Test: Reflectable
{
    var name99:String = ""
    var name3:String = ""
    var name2:String = ""
    var object: [String] = []
    var nallavanga: Dictionary<String,Any>?
    var testArray: [Test] = []
}

extension NSObject {
    
    func parseDictionoryToObject(jsonInfo: NSDictionary) {
        
        for (key, value) in jsonInfo {
            
            if let keyName = key as? String
            {
                if (value as AnyObject).isKind(of: NSDictionary.self)
                {
                    if let object = getClassObjectForString(keyName: keyName, isArray: false)
                    {
                        
                        object.parseDictionoryToObject(jsonInfo: value as! NSDictionary)
                        
                        if self.responds(to: Selector(keyName))
                        {
                            
                            self.setValue(object, forKey: keyName)
                            
                        }
                        
                    }
                    else
                    {
                        
                        continue
                        
                    }
                    
                }
                else if (value as AnyObject).isKind(of: NSArray.self)
                {
                    
                    if keyName == "roleType"
                    {
                        
                    }
                    
                    var valueArray: [NSObject] = []
                    
                    for item in (value as! NSArray)
                    {
                        
                        if (item as AnyObject).isKind(of: NSDictionary.self), let object = getClassObjectForString(keyName: keyName, isArray: true) {
                            
                            object.parseDictionoryToObject(jsonInfo: item as! NSDictionary)
                            
                            valueArray.append(object)
                            
                        } else {
                            
                            valueArray.append(item as! NSObject)
                            
                        }
                    }
                    
                    if self.responds(to: Selector(keyName))
                    {
                        
                        self.setValue(valueArray, forKey: keyName)
                        
                    }
                    
                }
                else
                {
                    if let string = value as? String, let boolValue = string.toBool()
                    {
                        self.setValue(boolValue, forKey: keyName)
                    }
                    else
                    {
                        if self.responds(to: Selector(keyName))
                        {
                            self.setValue(value, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    
    private func getClassObjectForString(keyName: String, isArray: Bool) -> NSObject? {
        
        var projectName =  Bundle.main.infoDictionary!["CFBundleName"] as! String
        
        projectName = projectName.replacingOccurrences(of: "-", with: "_")
        
        var capitalised = ""
        
        if isArray
        {
            capitalised = keyName
            
            if (keyName.substring(from: keyName.index(before: keyName
                .endIndex)) == "s")
            {
                if keyName != "address"
                {
                    capitalised = keyName.substring(to: keyName.index(before: keyName
                        .endIndex)).firstLetterCaps() + "DTO"
                }
                else
                {
                    capitalised = keyName.firstLetterCaps() + "DTO"
                }
            }
            else
            {
                capitalised = keyName.firstLetterCaps() + "DTO"
            }
        }
        else
        {
            capitalised = keyName.capitalizingFirstLetter() + "DTO"
        }
        
        var nsObjectSubClass = ObjectFactory<NSObject>.createInstance(className: "\(projectName).\(capitalised)")
        
        if nsObjectSubClass == nil
        {
            let capitalised = keyName.capitalized
            
            nsObjectSubClass = ObjectFactory<NSObject>.createInstance(className: "\(projectName).\(capitalised)")
            
            if nsObjectSubClass == nil
            {
                
                nsObjectSubClass = ObjectFactory<NSObject>.createInstance(className: "\(projectName).\(capitalised.substring(to: capitalised.index(before: capitalised.endIndex)))")
                
                
                if nsObjectSubClass == nil {
                    
                    if (capitalised.substring(to: capitalised.index(before: capitalised.endIndex)) == "Range") {
                        
                        nsObjectSubClass = ObjectFactory<NSObject>.createInstance(className: "\(projectName).\(capitalised.substring(to: capitalised.index(before: capitalised.endIndex)))1")
                        
                    }
                    
                }
                
            }
            
        }
        
        return nsObjectSubClass
        
    }
    
}

func swiftToJsonParser(parseObj : NSObject) -> AnyObject {
    
    var dictionary  =  Dictionary<String, AnyObject>()
    let properites: [String] = parseObj.propertys()
    
    for i in 0 ..< properites.count {
        
        let propertyName: String = properites[i]
        
        if propertyName == "accDepCost"
        {
            
        }
        
        if let value: AnyObject = parseObj.value(forKey: propertyName) as AnyObject?
        {
            if let stringobj = value as? String
            {
                if stringobj.characters.count > 0
                {
                    dictionary[propertyName] = stringobj.copy() as AnyObject?
                }
                else
                {
                    if propertyName == "note"
                    {
                        dictionary[propertyName as String] = "" as AnyObject?
                    }
                }
            }
            else if let numberobj = value as? NSNumber
            {
                dictionary[propertyName as String] = numberobj.copy() as AnyObject?
            }
            else if let arrobjs = value as? NSArray
            {
                let arrayString : NSMutableArray = NSMutableArray()
                var i = 0;
                for arrobj in arrobjs
                {
                    if let arrvalue = arrobj as? NSString
                    {
                        if arrvalue.length > 0
                        {
                            arrayString.add(arrvalue)
                            //arrayString[i] = arrvalue
                            i += 1
                        }
                    }
                    else if let arrvalue = arrobj as? NSNumber
                    {
                        
                        arrayString.add(arrvalue)
                        //arrayString[i] = arrvalue
                        i += 1
                        
                    }
                    else if(swiftToJsonParser(parseObj: arrobj as! NSObject).count > 0)
                    {
                        arrayString[i] = swiftToJsonParser(parseObj: arrobj as! NSObject)
                        i += 1
                    }
                }
                
                if(arrayString.count > 0)
                {
                    dictionary[propertyName as String] = arrayString.copy() as AnyObject?
                }
                else
                {
                    
                    if propertyName == ""
                    {
                        dictionary[propertyName as String] = NSArray() as AnyObject?
                    }
                }
                
            }
            else if let customobj = value as? NSObject
            { // must be custom object
                let objString: (AnyObject) = swiftToJsonParser(parseObj: customobj)
                if(objString.count > 0)
                {
                    dictionary[propertyName as String] = objString
                }
            }
            
        }
        
    }
    
    return dictionary as AnyObject
    
}
