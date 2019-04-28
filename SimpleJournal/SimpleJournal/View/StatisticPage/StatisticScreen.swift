//
//  StatisticScreen.swift
//  SimpleJournal
//
//  Created by yinzixie on 27/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit
import Charts

class StatisticScreen: UIViewController,TellStatisticPageCacheRefresh {
  
    @IBOutlet var FromDateTextField: UITextField!
    @IBOutlet var ToDateTextField: UITextField!
    @IBOutlet var PieChartView: PieChartView!
    
    var FromDatePicker: UIDatePicker!
    var ToDatePicker: UIDatePicker!
    
    var StatisticList: [MoodStatistic]!
    
    var FirstMoodPieChartData = PieChartDataEntry(value: 0)
    var SecondMoodPieChartData = PieChartDataEntry(value: 0)
    var ThirdMoodPieChartData = PieChartDataEntry(value: 0)
    var ForthMoodPieChartData = PieChartDataEntry(value: 0)
    
    var FinalDataListInPieChart = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("init statistic page")
        
        JournalListCache.tellStatisticPageCacheRefresh = self
        
        setDatePicker()
        setDatePickerLimitation()
        setPieChart()
    }
    
    private func setDatePicker() {
        FromDatePicker  = UIDatePicker()
        FromDatePicker.datePickerMode = .date
        FromDatePicker.addTarget(self, action: #selector(self.FromDateChanged(dataPicker:)), for: .valueChanged)
        FromDatePicker.date = DateInfo.timeStringToDate("1980-1-1  00:00:00")
        
        ToDatePicker = UIDatePicker()
        ToDatePicker.datePickerMode = .date
        ToDatePicker.addTarget(self, action: #selector(self.ToDateChanged(dataPicker:)), for: .valueChanged)
        ToDatePicker.date = Date()
        
        let SelfViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(TextTap(gestureRecognizer:)))
        //let SelfChartViewTapGesture = UITapGestureRecognizer(target: self.PieChartView, action: #selector(TextTap(gestureRecognizer:)))
        
        self.view.addGestureRecognizer(SelfViewTapGesture)
        //self.PieChartView.addGestureRecognizer(SelfChartViewTapGesture)
        
        FromDateTextField.inputView = FromDatePicker
        FromDateTextField.text = DateInfo.dateToDateString(FromDatePicker.date, dateFormat: "yyyy-MM-dd")
        ToDateTextField.inputView = ToDatePicker
        ToDateTextField.text = DateInfo.dateToDateString(ToDatePicker.date, dateFormat: "yyyy-MM-dd")
    }
    
    private func setDatePickerLimitation() {
        FromDatePicker.maximumDate = ToDatePicker.date
        
        ToDatePicker.minimumDate = FromDatePicker.date
        ToDatePicker.maximumDate = Date()
    }
    
    private func setPieChart() {
        FinalDataListInPieChart = []
        
        PieChartView.chartDescription?.text = "Statistic for moods"
        
        StatisticList = JournalListCache.statisticMoods(from:FromDatePicker.date,to:ToDatePicker.date)
        print(StatisticList)
        let count = StatisticList?.count ?? 0
        var reminder: Double = 0
        var total:Int = 0
        
        for mood in StatisticList {
            total += mood.Num ?? 0
        }
        if(count == 0){
            FirstMoodPieChartData.label = "None"
            FinalDataListInPieChart += [FirstMoodPieChartData]
        }
        
        if (count >= 1){
            print("test")
            FirstMoodPieChartData.value = Double((StatisticList?[0].Num!)!)
            FirstMoodPieChartData.label = StatisticList?[0].Mood
            FinalDataListInPieChart += [FirstMoodPieChartData]
            
            reminder +=  FirstMoodPieChartData.value
        }
        if (count >= 2){
            SecondMoodPieChartData.value = Double((StatisticList?[1].Num!)!)
            SecondMoodPieChartData.label = StatisticList?[1].Mood
            FinalDataListInPieChart += [SecondMoodPieChartData]
            
            reminder +=  SecondMoodPieChartData.value
        }
        if (count >= 3){
            ThirdMoodPieChartData.value = Double((StatisticList?[2].Num!)!)
            ThirdMoodPieChartData.label = StatisticList?[2].Mood
            FinalDataListInPieChart += [ThirdMoodPieChartData]
            
            reminder +=  ThirdMoodPieChartData.value
        }
        if (count >= 4){
            ForthMoodPieChartData.value = Double(total) - reminder
            ForthMoodPieChartData.label = "Other"
            FinalDataListInPieChart += [ForthMoodPieChartData]
        }
        //FinalDataListInPieChart = [FirstMoodPieChartData,SecondMoodPieChartData,ThirdMoodPieChartData,ForthMoodPieChartData]
        updatePieChart()
    }
    
    @objc func FromDateChanged(dataPicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        FromDateTextField.text = dateFormatter.string(from:  dataPicker.date)
        ToDatePicker.minimumDate = FromDatePicker.date
        
        self.view.endEditing(true)
        setPieChart()
    }
    
    @objc func ToDateChanged(dataPicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        ToDateTextField.text = dateFormatter.string(from:  dataPicker.date)
        FromDatePicker.maximumDate = ToDatePicker.date
      
        self.view.endEditing(true)
        setPieChart()
    }

    @objc func TextTap(gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    
    func remindStatisticPageCacheChanged() {
        print("Statistic recieve refresh")
        setPieChart()
    }
    
    func remindStatisticPageDeleteAJournal(indexPathInTable: IndexPath) {
        print("Statistic recieve refresh")
        setPieChart()
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
        let ChartDataSet = PieChartDataSet(entries:FinalDataListInPieChart,label: nil)
        let ChartData = PieChartData(dataSet: ChartDataSet)
        
        let colors = [UIColor.red,.orange,.blue,.yellow]
        
        ChartDataSet.colors = colors
        
        PieChartView.data = ChartData
    }
}
