//
//  Int.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 23.11.21.
//

import Foundation

extension Int {
    func typeOfWind() -> String {
        switch self {
        case 0...11, 349...360:
            return "north_wind".localized
        case 12...78:
            return "northeast_wind".localized
        case 79...101:
            return "east_wind".localized
        case 102...168:
            return "southeast_wind".localized
        case 169...191:
            return "south_wind".localized
        case 192...258:
            return "southwest_wind".localized
        case 259...281:
            return "west_wind".localized
        case 282...348:
            return "northwest_wind".localized
        default:
            return ""
        }
    }
}
