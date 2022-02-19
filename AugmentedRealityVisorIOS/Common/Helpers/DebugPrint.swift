//
//  DebugPrint.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 11.02.2022.
//

import Foundation

//MARK: - Debug
func printIfDebug(_ items: Any...) {
    #if DEBUG
    print(items)
    #endif
}
