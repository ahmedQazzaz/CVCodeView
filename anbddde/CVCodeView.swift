//
//  CVCodeView.swift
//  anbddde
//
//  Created by Ahmed Qazzaz on 5/10/18.
//  Copyright © 2018 Ahmed Qazzaz. All rights reserved.
//

import UIKit


@IBDesignable
class CVCodeView: UIView {
    
    
    @IBOutlet var codeDelegate : CVCodeViewDelegate?
    
    
    @IBInspectable var digits : Int = 4
    @IBInspectable var space : Int = 8
    @IBInspectable var line_height : Int = 2
    
    @IBInspectable var line_color : UIColor = UIColor.gray
    @IBInspectable var line_selected : UIColor = UIColor.white
    @IBInspectable var text_color : UIColor = UIColor.white
    @IBInspectable var text_size : CGFloat = 17.0
    @IBInspectable var text_placeHolder : String = "•"
    @IBInspectable var text_placeHolder_color : UIColor = UIColor.white
    
    var stringValue : String{
        
        var str = ""
        for item in fields{
            let txt  = item["field"] as! UITextField
            str.append(txt.text ?? "")
        }
        
            return str;
        
    }
    private var fields : [[String:Any]] = []
    private var index : Int = -1;
    private var currentField : [String: Any]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTouchOnView(_:))))
    }
    
    @objc func didTouchOnView(_ gesture : UITapGestureRecognizer){
        
        let tt =  self.getTheFirstSelectedField()
        if(tt != nil){
            self.selectFiled(tt!)
        }
        
    }
    
    func getTheFirstSelectedField()->[String:Any]?{
        
        var count = 0;
        for item in fields{
            let txt  = item["field"] as! UITextField
            if(txt.text?.count == 0){
                
                index = count
                
                return item
            }
            count+=1
        }
        return nil
    }
    
    func selectFiled(_ select : Dictionary<String, Any>){
        
        currentField = select
        
        let txt  = select["field"] as! UITextField
        txt.attributedPlaceholder =   NSAttributedString(string: txt.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor : self.line_selected])
        txt.becomeFirstResponder()
        (currentField!["bottom"] as! UIView).backgroundColor = self.line_selected
        
    }
    
    func deSelectField(_ select : Dictionary<String, Any>){
        
        let txt  = select["field"] as! UITextField
        txt.attributedPlaceholder =   NSAttributedString(string: txt.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor : self.text_placeHolder_color])
        
        (currentField!["bottom"] as! UIView).backgroundColor = self.line_color
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if(digits < 3){
            digits = 3
        }
        
        if(fields.count != digits){
            fields = []
            let FWidth = (Int(self.frame.width) - space) / digits
            
            for i in 0..<digits{
                
                let txt = specialTextField(frame: CGRect(x: (i * FWidth) , y: 0, width: (FWidth - space), height: Int(self.frame.height) - line_height))
                //txt.isUserInteractionEnabled = false
                txt.textColor = self.text_color
                txt.placeholder = self.text_placeHolder
                txt.textAlignment = .center
                
                if #available(iOS 10.0, *) {
                    txt.keyboardType = .asciiCapableNumberPad
                } else {
                    txt.keyboardType = .numberPad
                }
                txt.tintColor = self.tintColor
                txt.delegate = self
                txt.attributedPlaceholder =   NSAttributedString(string: txt.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor : self.text_placeHolder_color])
                txt.font = UIFont.systemFont(ofSize: CGFloat(FWidth / 2))
                
                let bottomLine = UIView(frame: CGRect(x: Int(txt.frame.origin.x), y: Int(self.frame.height) - line_height, width: Int(txt.frame.width), height: line_height))
                
                bottomLine.backgroundColor = self.line_color
                
                let field = ["field" : txt, "bottom" : bottomLine]
                
                if(currentField == nil){
                    currentField = field
                }
                
                self.addSubview(txt)
                self.addSubview(bottomLine)
                
                fields.append(field)
                
                let block = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
                block.backgroundColor = UIColor.clear
                self.addSubview(block)
                
            }
            
            
        }
        
    }

}

extension CVCodeView : UITextFieldDelegate{
    
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(string.count == 0){
            if(index > 0){
                
                if(textField.text == ""){
                    //(currentField!["field"] as! UITextField).text = ""
                }
                
                self.deSelectField(currentField!)
                index-=1
                self.selectFiled(fields[index])
                
                
            }
            
            textField.text = ""
        }else{
            if(textField.text?.count == 0){
                
                if(index < fields.count-1){
                    self.deSelectField(currentField!)
                    index+=1
                    self.selectFiled(fields[index])
                }else{
                    
                        if(self.codeDelegate != nil){
                            self.codeDelegate!.didFinishEnterCode?(field: self, text: "\(self.stringValue)\(string)")
                        }
                    
                }
                
              textField.text = string
            }else{
                
                if(index < fields.count-1){
                    self.deSelectField(currentField!)
                    index+=1
                    self.selectFiled(fields[index])
                    (currentField!["field"] as! UITextField).text = string
                }
                
                        if(self.codeDelegate != nil){
                            self.codeDelegate!.didFinishEnterCode?(field: self, text: self.stringValue)
                        }
                
            }
        }
        
        
        
        return false
    }
    
    
    
}

@objc protocol CVCodeViewDelegate {
    @objc optional
     func didFinishEnterCode(field : CVCodeView, text : String)
}

class specialTextField : UITextField{
    override func deleteBackward() {
        super.deleteBackward()
        self.delegate?.textField!(self, shouldChangeCharactersIn: NSMakeRange(0, 0), replacementString: "")
    }
}
