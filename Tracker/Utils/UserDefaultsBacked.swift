//
//  UserDefaultsBacked.swift
//  Tracker
//
//  Created by Vitaly on 01.09.2023.
//

import Foundation

@propertyWrapper
struct UserDefaultsBacked<Value> { // наша обёртка должна работать с любым типом данных, поэтому добавим в неё дженерик
    let key: String // ключ для записи
    var storage: UserDefaults = .standard // экземпляр UserDefaults
    
    var wrappedValue: Value? { // значение свойства, которое мы оборачиваем
        get {
            return storage.value(forKey: key) as? Value // переписываем чтение
        }
        set {
            storage.setValue(newValue, forKey: key) // переписываем запись
        }
    }
} 
