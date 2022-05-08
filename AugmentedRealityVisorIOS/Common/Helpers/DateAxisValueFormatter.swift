//
//  DateAxisValueFormatter.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 15.04.2022.
//

import Foundation
import Charts

//@objc(ChartDateAxisValueFormatter)
open class DateAxisValueFormatter: NSObject, IAxisValueFormatter {
    private var _dateFormatter: DateFormatter = DateFormatter()
    
    @objc public init(with dateFormat: String = "HH:mm:ss") {
        self._dateFormatter.dateFormat = dateFormat
        super.init()
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        let stringDate = _dateFormatter.string(from: date)
        return stringDate
    }
}
