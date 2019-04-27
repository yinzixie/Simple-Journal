//
//  StatisticScreen.swift
//  SimpleJournal
//
//  Created by yinzixie on 27/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit
import Charts

class StatisticScreen: UIViewController {

    @IBOutlet var FromDateTextField: UITextField!
    @IBOutlet var ToDateTextField: UITextField!
    @IBOutlet var PieChartView: PieChartView!
    
    var MoodHappyPieChartData = PieChartDataEntry(value: 0)
    var MoodSadPieChartData = PieChartDataEntry(value: 0)
    
    var FinalDataListInPieChart = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        PieChartView.chartDescription?.text = "TEXT"
        
        MoodHappyPieChartData.value = 10
        MoodHappyPieChartData.label = "Happy"
        
        MoodSadPieChartData.value = 10
        MoodSadPieChartData.label = "Sad"
        
        FinalDataListInPieChart = [MoodHappyPieChartData,MoodSadPieChartData]
        
        updatePieChart()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updatePieChart() {
        let ChartDataSet = PieChartDataSet(entries:FinalDataListInPieChart,label: "???")
        let ChartData = PieChartData(dataSet: ChartDataSet)
        
        let colors = [UIColor.red,.blue]
        
        ChartDataSet.colors = colors as! [NSUIColor]
        
        PieChartView.data = ChartData
    }
    
    

}
