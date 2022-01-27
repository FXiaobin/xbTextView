//
//  ViewController.swift
//  xbTextViewDemo
//
//  Created by huadong on 2022/1/27.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let textV = xbTextView(frame: CGRect(x: 10, y: 100, width: self.view.bounds.width - 20, height: 100))
        textV.backgroundColor = UIColor.orange
        textV.textColor = UIColor.white
        textV.font = UIFont.systemFont(ofSize: 16.0)
        textV.tintColor = UIColor.red
        
//        textV.text = "中国天气网讯 今年以来最强雨雪过程持续，今天开始（1月27日）将进入此轮过程的最强时段，中央气象台升级发布了暴雪黄色预警，河南西部、湖北大部、湖南北部和安徽中部等7省区部分地区有大到暴雪。在雨雪天气和冷空气影响下，南方多地湿冷将贯穿一整天，华南29日气温也将下降。中国天气网讯 今年以来最强雨雪过程持续，今天开始（1月27日）将进入此轮过程的最强时段，中央气象台升级发布了暴雪黄色预警，河南西部、湖北大部、湖南北部和安徽中部等7省区部分地区有大到暴雪。在雨雪天气和冷空气影响下，南方多地湿冷将贯穿一整天，华南29日气温也将下降。"
        textV.placeholder = "请输入内容"
        textV.placeholderColor = UIColor.green
        
        
        textV.isAutoHeight = true
        
        textV.minHeight = 50.0
//        textV.maxHeight = 120.0
        
//        textV.maxLength = 260
        textV.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        textV.xb_Delegate = self
        
        
        self.view.addSubview(textV)
        
        
    }


}

extension ViewController: xbTextViewDelegate {
    func xb_heightWith(textView: xbTextView, textHeight: CGFloat, textViewHeight: CGFloat) {
        debugPrint(" -- textHeight = \(textHeight), textViewHeight = \(textViewHeight) ")
    }
  
    func xb_textViewDidChanged(textView: xbTextView, text: String?) {
        debugPrint("--- 正在编辑中 text = \(String(describing: text))")
    }
    
    func xb_textViewDidEndEditing(textView: xbTextView, text: String?) {
        debugPrint("--- 结束编辑 text = \(String(describing: text))")
    }
}
