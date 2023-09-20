//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Vitaly on 15.09.2023.
//

import Foundation
import YandexMobileMetrica

class AnalyticsService {
    
    static func activate() {
        // Initializing the AppMetrica SDK.
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "5c9bec4a-acdc-411b-b3d6-3c5a24714071") else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    //let params : [AnyHashable : Any] = ["key1": "value1", "key2": "value2"]
    func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func createParams(screen: String = "Main", item: String? = nil) -> [AnyHashable : Any] {
        var params: [AnyHashable : Any]  = [:]
        params["screen"] = screen
        
        guard let item = item else {  return params }
        params["item"] = item
        
        return params
    }
    /// add_track для кнопки добавления нового трека
    func eventOpen() {
        report(event: "open", params: createParams())
    }
    /// add_track для кнопки добавления нового трека
    func eventClose() {
        report(event: "close", params: createParams())
    }
    /// add_track для кнопки добавления нового трека
    func eventCreateTracker() {
        report(event: "click", params: createParams(item: "add_track"))
    }
    /// track для тапа на кнопку о выполнении трека
    func eventTracker() {
        report(event: "click", params: createParams(item: "track"))
    }
    /// filter для тапа на кнопку фильтров
    func eventFilter() {
        report(event: "click", params: createParams(item: "filter"))
    }
    /// edit для тапа на кнопку редактировать в контекстном меню
    func eventEdit() {
        report(event: "click", params: createParams(item: "edit"))
    }
    /// delete для тапа на кнопку удалить в контекстном меню
    func eventDelete() {
        report(event: "click", params: createParams(item: "delete"))
    }
}
