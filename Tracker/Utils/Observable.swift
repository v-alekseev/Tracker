//
//  Observable.swift
//  EmojiMixer
//
//  Created by Vitaly on 29.08.2023.
//

import Foundation

@propertyWrapper
final class Observable<Value> {
    private var onChange: (() -> Void)? = nil
    
    var wrappedValue: Value {
        didSet { // вызываем функцию после изменения обёрнутого значения
            onChange?()
        }
    }
    
    var projectedValue: Observable<Value> { // возвращает экземпляр самого property wrapper
        return self
    }
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    func bind(action: @escaping () -> Void) { // функция для добавления функции, вызывающей изменения
        self.onChange = action
    }
} 
