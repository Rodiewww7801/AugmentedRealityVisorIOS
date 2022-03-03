//
//  Tabs.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 02.03.2022.
//

import Foundation
import SwiftUI

protocol Tab {
    var name: String { get }
}

//enum SwitchedTab: Tab {
//    case analyzer
//    case qrScan
//    case library
//    case profile
//
//    var name: String {
//        switch self {
//        case .analyzer: return "Analyzer"
//        case .qrScan: return "QR Scan"
//        case .library: return "Library"
//        case .profile: return "Profile"
//        }
//    }
//}

enum OnTopTab: Tab {
    case none
    case catalogue
    
    var name: String {
        switch self {
        case .none: return "None"
        case .catalogue: return "Catalogue"
        }
    }
}

enum TabBarOptions: Int, Identifiable, CaseIterable, Tab {
    case analyzer
    case qrScan
    case library
    case profile
    
    var imageName: String {
        switch self {
        case .analyzer: return "chart.xyaxis.line"
        case .qrScan: return "qrcode.viewfinder"
        case .library: return "list.bullet.indent"
        case .profile: return "person.fill"
        }
    }
    
    var scale: CGFloat {
        switch self {
        case .analyzer: return 0.75
        case .qrScan: return 0.75
        case .library: return 0.75
        case .profile: return 0.75
        }
    }
    
    var name: String {
        switch self {
        case .analyzer: return "Analyzer"
        case .qrScan: return "QR Scan"
        case .library: return "Library"
        case .profile: return "Profile"
        }
    }
    
    var id: String {
        return name
    }
}

extension TabBarOptions {
    init?(name: String) {
        switch name.lowercased() {
        case "analyzer": self = .analyzer
        case "qr scan": self = .qrScan
        case "library": self = .library
        case "profile": self = .profile
        default: return nil
        }
    }
}
