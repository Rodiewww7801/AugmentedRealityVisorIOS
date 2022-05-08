//
//  ARItemObjectStateView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 06.05.2022.
//

import Foundation
import SwiftUI
import Charts

struct ARItemObjectStateView: View {
    @ObservedObject var arItemViewModel : ARItemViewModel
    
    var body: some View {
        VStack() {
            ARItemObjectStateUIViewRepresentable(viewModel: arItemViewModel)
        }
    }
}

class ARItemObjectStateUIView: UIViewController {
    private var stackView = UIStackView()
    private var chartView = LineChartView()
    private var defaultHexColor: String = "#0037ff"
    private var valueText = UITextView()
    private var valueDescription = UITextView()
    var viewModel: ARItemViewModel
    
    init(viewModel: ARItemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupContainer()
    }
    
    private func setupContainer() {
        view.addSubview(stackView)
        
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        setupChart()
        setupTextView()
        setupDescriptionText()
    }
    
    private func setupChart() {
        guard viewModel.objectState?.drawChart ?? false else {
            chartView.isHidden = true
            return
        }
        guard !viewModel.entries.isEmpty else  { return }
        
        let dataSet = LineChartDataSet(entries: viewModel.entries)
        chartView.rightAxis.enabled = false
        chartView.data = LineChartData(dataSet: dataSet)
        chartView.data?.setDrawValues(false)
        chartView.xAxis.labelPosition = .bottom
        chartView.highlighter = nil
        chartView.setScaleEnabled(false)
        chartView.legend.enabled = false
        formatDataSet(dataSet: dataSet)
        formatLeftAxis(leftAxis: chartView.leftAxis)
        formatXAxis(xAxis: chartView.xAxis)
        
        stackView.addArrangedSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 280).isActive = true
    }
    
    func formatDataSet(dataSet: LineChartDataSet) {
        let color = UIColor(.black).hexStringToUIColor(hex: viewModel.objectState?.hexColor ?? defaultHexColor)
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
    
    private func setupTextView() {
        guard let objectValue = viewModel.objectState else { return }
        let attributetString = NSMutableAttributedString(string: "\(objectValue.name): ",
                                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)])
        attributetString.append(NSAttributedString(string: "\(objectValue.state)",
                                                   attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]))
                                                                
        valueText.attributedText = attributetString
        valueText.textAlignment = .center
        valueText.isEditable = false
        valueText.isScrollEnabled = false
        valueText.backgroundColor = .clear
        stackView.addArrangedSubview(valueText)
        
        valueText.translatesAutoresizingMaskIntoConstraints = false
        valueText.topAnchor.constraint(equalTo: objectValue.drawChart ? chartView.bottomAnchor : stackView.topAnchor).isActive = true
        valueText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupDescriptionText() {
        guard let objectValue = viewModel.objectState else { return }
        guard let description =  viewModel.objectState?.description else {
            valueDescription.isHidden = true
            return
            
        }
        
        let attributetString = NSMutableAttributedString(string: description,
                                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                                                                      NSAttributedString.Key.foregroundColor : UIColor.gray])
        
        valueDescription.attributedText = attributetString
        valueDescription.isHidden = false
        valueDescription.textAlignment = .center
        valueDescription.isEditable = false
        valueDescription.isScrollEnabled = false
        valueDescription.backgroundColor = .clear
        stackView.addArrangedSubview(valueDescription)
        
        valueDescription.translatesAutoresizingMaskIntoConstraints = false
        valueDescription.topAnchor.constraint(equalTo: objectValue.drawChart ? chartView.bottomAnchor : stackView.topAnchor, constant: 35).isActive = true
    }
    
    func updateView() {
        setupChart()
        setupTextView()
        setupDescriptionText()
    }
}

struct ARItemObjectStateUIViewRepresentable: UIViewControllerRepresentable {
    @ObservedObject var viewModel: ARItemViewModel
    
    func makeUIViewController(context: Context) -> some ARItemObjectStateUIView {
        let view = ARItemObjectStateUIView(viewModel: viewModel)
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.viewModel = viewModel
        uiViewController.updateView()
    }
}
