//
//  SettingsBundleHelper.swift
//  switchEnvironemnt
//
//  Created by Dario Arrigo on 02/07/2019.
//  Copyright © 2019 syskoplan. All rights reserved.
//

import Foundation

class SettingsBundleHelper {
    
    struct SettingsBundleKeys {
        static let appVersionKey = "settings.version"
        static let buildKey = "settings.build"
    }
    
    class func checkAndExecuteSettings() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        UserDefaults.standard.set(version, forKey: SettingsBundleKeys.appVersionKey)
        UserDefaults.standard.set(build, forKey: SettingsBundleKeys.buildKey)
    }
}
