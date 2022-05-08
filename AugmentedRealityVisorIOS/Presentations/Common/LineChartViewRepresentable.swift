//
//  BarChartView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 14.04.2022.
//

import Foundation
import SwiftUI
import Charts

struct LineChartViewRepresentable: UIViewRepresentable {
    var entries: [ChartDataEntry]
    var hexColorChart: String?
    var defaultHexColor: String = "#0037ff"
    
    func makeUIView(context: Context) -> some LineChartView {
        return LineChartView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard !entries.isEmpty else  { return }
        let dataSet = LineChartDataSet(entries: entries)
        uiView.rightAxis.enabled = false
        uiView.data = LineChartData(dataSet: dataSet)
        uiView.data?.setDrawValues(false)
        uiView.xAxis.labelPosition = .bottom
        uiView.highlighter = nil
        uiView.setScaleEnabled(false)
        uiView.legend.enabled = false
        formatDataSet(dataSet: dataSet)
        formatLeftAxis(leftAxis: uiView.leftAxis)
        formatXAxis(xAxis: uiView.xAxis)
    }
    
    func formatDataSet(dataSet: LineChartDataSet) {
        let color = UIColor(.black).hexStringToUIColor(hex: hexColorChart ?? defaultHexColor)
        dataSet.colors = [color]
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 1.5
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        dataSet.valueFormatter = DefaultValueFormatter(formatter: numberFormatter)
    }
    
    func formatLeftAxis(leftAxis: YAxis) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: numberFormatter)
        leftAxis.axisMinimum = 0
    }
    
    func formatXAxis(xAxis: XAxis) {
        xAxis.valueFormatter = DateAxisValueFormatter(with: "mm:ss")
    }
}

struct TransactionBarChartView_Preview: PreviewProvider {
    static var previews: some View {
        return LineChartViewRepresentable(entries: fakeEntities)
    }
}

var fakeEntities: [ChartDataEntry]  = {
    var array:  [ChartDataEntry] = []
        for index in 0...15 {
            let dateDouble = Double(Date(timeIntervalSinceNow: TimeInterval(index * 60)).timeIntervalSince1970)
            let date = Date(timeIntervalSinceNow: TimeInterval(index * 60))
            let data = ChartDataEntry(x: dateDouble,  y: Double.random(in: 0.0...5.2))
            array.append(data)
        }
    return array
}()
