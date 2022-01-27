//
//  xbTextView.swift
//  FSCycleSwift
//
//  Created by huadong on 2022/1/27.
//

import UIKit

protocol xbTextViewDelegate: UITextViewDelegate {
    
    func xb_textViewDidChanged(textView: xbTextView, text: String?)
    
    func xb_textViewDidEndEditing(textView: xbTextView, text: String?)
    
    func xb_heightWith(textView: xbTextView, textHeight: CGFloat, textViewHeight: CGFloat)
    
}

class xbTextView: UITextView {

    /** 占位文字*/
    var placeholder: String? = "请输入..."
    /** 占位文字颜色*/
    var placeholderColor: UIColor? = UIColor.lightGray
    /** 属性字符串占位符*/
    var attributedPlaceholder: NSAttributedString?
    
    weak var xb_Delegate: xbTextViewDelegate?
    
    // Calculate and adjust textview's height
    private var oldHeight: CGFloat = 0.0
    
    /** 是否去除空字符串和换行符 默认false*/
    var trimWhiteSpaceWhenEndEditing: Bool = false
    
    /** 是否自适应高度*/
    var isAutoHeight: Bool = false
    
    /** 最大字符*/
    var maxLength: Int = 0
    
    /** 最大高度*/
    var maxHeight: CGFloat = 0.0 {
        didSet {
            forceLayoutSubviews()
        }
    }
    
    /** 最小高度*/
    var minHeight: CGFloat = 0.0 {
        didSet {
            forceLayoutSubviews()
        }
    }
    
    
    var padding: UIEdgeInsets = UIKit.UIEdgeInsets.zero {
        didSet{
            self.textContainerInset = padding
        }
    }
 
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        //contentMode = .redraw
        
        // 默认没有边距
        self.contentInset = UIEdgeInsets.zero
        self.textContainerInset = UIEdgeInsets.zero
        self.textContainer.lineFragmentPadding = 0.0
        
        // 设置默认字体
        self.font = UIFont.systemFont(ofSize: 15)
        // 使用通知监听文字改变
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notification:)), name: UITextView.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing(notification:)), name: UITextView.textDidEndEditingNotification, object: self)
    }

    /** 强制更新布局*/
    private func forceLayoutSubviews() {
        oldHeight = 0.0
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    /** 滚动到顶部或者底部*/
    private func scrollToCorrectPosition() {
        if self.isFirstResponder {
            self.scrollRangeToVisible(NSMakeRange(-1, 0)) // Scroll to bottom
        } else {
            self.scrollRangeToVisible(NSMakeRange(0, 0)) // Scroll to top
        }
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        
        let size = sizeThatFits(CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height
        
        if height == oldHeight {
            return
        }
        oldHeight = height
        
        // Constrain minimum height
        height = minHeight > 0 ? max(height, minHeight) : height
        
        // Constrain maximum height
        height = maxHeight > 0 ? min(height, maxHeight) : height
        
        
        if isAutoHeight {
            var frame = self.frame
            frame.size.height = height
            self.frame = frame
        }
        
        //debugPrint("---- size = \(size) ----")
        
        if let delegate = self.xb_Delegate {
            delegate.xb_heightWith(textView: self, textHeight: size.height, textViewHeight: height)
        }
    }
   
    
    override func draw(_ rect: CGRect) {
        // 如果有文字,就直接返回,不需要画占位文字
        if self.hasText {
            return
        }
      
        // 文字
        var rect1 = rect
        // self.textContainerInset默认有边距 5 8
        // rect1.origin.x = 5
        // rect1.origin.y = 8
        
        // 设置textView的text没有边距
        // self.contentInset = UIEdgeInsets.zero
        // self.textContainerInset = UIEdgeInsets.zero
        
        rect1.origin.x = self.textContainerInset.left
        rect1.origin.y = self.textContainerInset.top
        rect1.size.width = rect1.size.width - 2*rect1.origin.x
        
        if let attribtedPlaceText = self.attributedPlaceholder {
            (attribtedPlaceText.string as NSString).draw(in: rect1)
        
        }else if let placeholder = self.placeholder{
            // 属性
            let attrs: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: self.placeholderColor as Any, NSAttributedString.Key.font: self.font!]
            
            (placeholder as NSString).draw(in: rect1, withAttributes: attrs)
        }
        
    }

    @objc func textDidChange(notification: Notification) {
        
        if let sender = notification.object as? xbTextView, sender == self {
            if trimWhiteSpaceWhenEndEditing {
                text = text?.trimmingCharacters(in: .whitespacesAndNewlines)
            }

            if maxLength > 0 && text.count > maxLength {
                let endIndex = text.index(text.startIndex, offsetBy: maxLength)
                text = String(text[..<endIndex])
                undoManager?.removeAllActions()
            }
            
            if let delegate = self.xb_Delegate {
                delegate.xb_textViewDidChanged(textView: self, text: self.text)
            }
            
            // 会重新调用drawRect:方法
            self.setNeedsDisplay()
            
            // 会重新调用布局layoutSubviews方法
            self.setNeedsLayout()
        }
        
    }
    
    // Trim white space and new line characters when end editing.
    @objc func textDidEndEditing(notification: Notification) {
        if let sender = notification.object as? xbTextView, sender == self {
//            if trimWhiteSpaceWhenEndEditing {
//                text = text?.trimmingCharacters(in: .whitespacesAndNewlines)
//                // setNeedsDisplay()
//                // self.setNeedsLayout()
//            }
//             // scrollToCorrectPosition()
            
            if let delegate = self.xb_Delegate {
                delegate.xb_textViewDidEndEditing(textView: self, text: self.text)
            }
            
        }
    }

}

