//
//  PopupDatePicker.swift
//  User.iPhone
//
//  Created by Trung Dao on 5/27/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//
import UIKit
import Foundation
import ObjectMapper
import AlamofireObjectMapper
import SClientData
import SClientModel
import CoreLocation
import RealmSwift
import GoogleMaps

protocol PopupDatePickerDelegate: class {
    func didChooseDateTime(_ sender: PopupDatePicker)
}


open class PopupDatePicker: UIView, UIPickerViewDelegate {
    
    open static var instance: PopupDatePicker?
    
    open var name: String!
    open var txtCapTion: UILabel!
    open var dateValue: Date = Date()
    
    open var isCancel: Bool = true
    
    var datePicker:  UIDatePicker!
    var pnlButtonArea:  UIView!
    
    var  btn30Minute: UIButton!
    var  btn1Hour: UIButton!
    var  btn2Hour: UIButton!
    
    var  btn5Hour: UIButton!
    var  btn10Hours: UIButton!
    var  btn1Day: UIButton!

    var  btnCancel: UIButton!
    var  btnApply: UIButton!
    
    var lblNotification: UILabel!

    weak var delegate:PopupDatePickerDelegate?
    
    
    open static func show() -> PopupDatePicker {
        if(instance == nil){
            
            let scrRect = UIScreen.main.bounds
            instance = PopupDatePicker(frame: scrRect)

        }
        
        instance!.dateValue = Date()
        instance!.invalidateButtons()
        return instance!
    }
    
    public override init(frame: CGRect){
    
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.alpha = 1.0
        
        txtCapTion = UILabel(frame: CGRect(x: 0,y: 0,width: 200,height: 30))
        txtCapTion.text = ""
        txtCapTion.font = txtCapTion.font.withSize(17)
        txtCapTion.textColor = UIColor.black
        txtCapTion.textAlignment = NSTextAlignment.center
        txtCapTion.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(txtCapTion)
        txtCapTion.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -50).isActive = true
        txtCapTion.heightAnchor.constraint(equalToConstant: 50).isActive = true
        txtCapTion.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        txtCapTion.topAnchor.constraint(equalTo: self.topAnchor, constant: 30.0).isActive = true
        
        
        btn30Minute   = UIButton(type: UIButtonType.custom) as UIButton
        btn30Minute.tag = 30
        btn30Minute.setTitle("30 phút ", for: UIControlState())
        btn30Minute.titleLabel!.font =   btn30Minute.titleLabel!.font.withSize(15)
        btn30Minute.titleLabel!.textAlignment = NSTextAlignment.center
        btn30Minute.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btn30Minute.titleLabel!.lineBreakMode = .byTruncatingTail
        btn30Minute.contentHorizontalAlignment = .center
        btn30Minute.contentVerticalAlignment = .center
        btn30Minute.contentMode = .scaleToFill
        btn30Minute.translatesAutoresizingMaskIntoConstraints = false
        btn30Minute.isUserInteractionEnabled = true
        btn30Minute.setBackgroundImage( ImageHelper.resize(UIImage(named: "SmallBlueButton2.png")!, newWidth: nil ), for: UIControlState.selected)
        btn30Minute.setBackgroundImage( ImageHelper.resize(UIImage(named: "SmallFlatButton2.png")!, newWidth: nil ), for: UIControlState())
        btn30Minute.setTitleColor(UIColor.black, for: UIControlState())
        btn30Minute.setTitleColor(UIColor.white, for: .selected)
        self.addSubview(btn30Minute)
        btn30Minute.widthAnchor.constraint(equalToConstant: 80).isActive = true
        btn30Minute.heightAnchor.constraint(equalToConstant: 35).isActive = true
        btn30Minute.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 17.0).isActive = true
        btn30Minute.topAnchor.constraint(equalTo: txtCapTion.bottomAnchor, constant: 10).isActive = true

        
        
        btn1Hour   = UIButton(type: UIButtonType.custom) as UIButton
        btn1Hour.tag = 60
        btn1Hour.setTitle("1 giờ ", for: UIControlState())
        btn1Hour.titleLabel!.font =   btn1Hour.titleLabel!.font.withSize(15)
        btn1Hour.titleLabel!.textAlignment = NSTextAlignment.center
        btn1Hour.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btn1Hour.titleLabel!.lineBreakMode = .byTruncatingTail
        btn1Hour.contentHorizontalAlignment = .center
        btn1Hour.contentVerticalAlignment = .center
        btn1Hour.contentMode = .scaleToFill
        btn1Hour.translatesAutoresizingMaskIntoConstraints = false
        btn1Hour.isUserInteractionEnabled = true
        btn1Hour.setBackgroundImage( ImageHelper.resize(UIImage(named: "SmallBlueButton2.png")!, newWidth: nil ), for: UIControlState.selected)
        btn1Hour.setBackgroundImage( ImageHelper.resize(UIImage(named: "SmallFlatButton2.png")!, newWidth: nil ), for: UIControlState())
        btn1Hour.setTitleColor(UIColor.black, for: UIControlState())
        btn1Hour.setTitleColor(UIColor.white, for: .selected)
        self.addSubview(btn1Hour)
        btn1Hour.widthAnchor.constraint(equalToConstant: 80).isActive = true
        btn1Hour.heightAnchor.constraint(equalToConstant: 35).isActive = true
        btn1Hour.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        btn1Hour.centerYAnchor.constraint(equalTo: btn30Minute.centerYAnchor, constant: 0.0).isActive = true
        
        
        btn2Hour   = UIButton(type: UIButtonType.custom) as UIButton
        btn2Hour.tag = 120
        btn2Hour.setTitle("2 giờ ", for: UIControlState())
        btn2Hour.titleLabel!.font =   btn2Hour.titleLabel!.font.withSize(15)
        btn2Hour.titleLabel!.textAlignment = NSTextAlignment.center
        btn2Hour.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btn2Hour.titleLabel!.lineBreakMode = .byTruncatingTail
        btn2Hour.contentHorizontalAlignment = .center
        btn2Hour.contentVerticalAlignment = .center
        btn2Hour.contentMode = .scaleToFill
        btn2Hour.translatesAutoresizingMaskIntoConstraints = false
        btn2Hour.isUserInteractionEnabled = true
        btn2Hour.setBackgroundImage( ImageHelper.resize(UIImage(named: "SmallBlueButton2.png")!, newWidth: nil ), for: UIControlState.selected)
        btn2Hour.setBackgroundImage( ImageHelper.resize(UIImage(named: "SmallFlatButton2.png")!, newWidth: nil ), for: UIControlState())
        btn2Hour.setTitleColor(UIColor.black, for: UIControlState())
        btn2Hour.setTitleColor(UIColor.white, for: .selected)
        self.addSubview(btn2Hour)
        btn2Hour.widthAnchor.constraint(equalToConstant: 80).isActive = true
        btn2Hour.heightAnchor.constraint(equalToConstant: 35).isActive = true
        btn2Hour.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -17.0).isActive = true
        btn2Hour.centerYAnchor.constraint(equalTo: btn30Minute.centerYAnchor, constant: 0.0).isActive = true
        
        
        btn5Hour   = UIButton(type: UIButtonType.custom) as UIButton
        btn5Hour.tag = 300
        btn5Hour.setTitle("5 giờ ", for: UIControlState())
        btn5Hour.titleLabel!.font =   btn5Hour.titleLabel!.font.withSize(15)
        btn5Hour.titleLabel!.textAlignment = NSTextAlignment.center
        btn5Hour.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btn5Hour.titleLabel!.lineBreakMode = .byTruncatingTail
        btn5Hour.contentHorizontalAlignment = .center
        btn5Hour.contentVerticalAlignment = .center
        btn5Hour.contentMode = .scaleToFill
        btn5Hour.translatesAutoresizingMaskIntoConstraints = false
        btn5Hour.isUserInteractionEnabled = true
        btn5Hour.setBackgroundImage( ImageHelper.resize(UIImage(named: "SmallBlueButton2.png")!, newWidth: nil ), for: UIControlState.selected)
        btn5Hour.setBackgroundImage( ImageHelper.resize(UIImage(named: "SmallFlatButton2.png")!, newWidth: nil ), for: UIControlState())
        btn5Hour.setTitleColor(UIColor.black, for: UIControlState())
        btn5Hour.setTitleColor(UIColor.white, for: .selected)
        self.addSubview(btn5Hour)
        btn5Hour.widthAnchor.constraint(equalToConstant: 80).isActive = true
        btn5Hour.heightAnchor.constraint(equalToConstant: 35).isActive = true
        btn5Hour.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 17.0).isActive = true
        btn5Hour.topAnchor.constraint(equalTo: btn30Minute.bottomAnchor, constant: 10).isActive = true
        
        btn10Hours   = UIButton(type: UIButtonType.custom) as UIButton
        btn10Hours.tag = 600
        btn10Hours.setTitle("10 giờ ", for: UIControlState())
        btn10Hours.titleLabel!.font =   btn10Hours.titleLabel!.font.withSize(15)
        btn10Hours.titleLabel!.textAlignment = NSTextAlignment.center
        btn10Hours.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btn10Hours.titleLabel!.lineBreakMode = .byTruncatingTail
        btn10Hours.contentHorizontalAlignment = .center
        btn10Hours.contentVerticalAlignment = .center
        btn10Hours.contentMode = .scaleToFill
        btn10Hours.translatesAutoresizingMaskIntoConstraints = false
        btn10Hours.isUserInteractionEnabled = true
        btn10Hours.setBackgroundImage( ImageHelper.resize(UIImage(named: "SmallBlueButton2.png")!, newWidth: nil ), for: UIControlState.selected)
        btn10Hours.setBackgroundImage( ImageHelper.resize(UIImage(named: "SmallFlatButton2.png")!, newWidth: nil ), for: UIControlState())
        btn10Hours.setTitleColor(UIColor.black, for: UIControlState())
        btn10Hours.setTitleColor(UIColor.white, for: .selected)
        self.addSubview(btn10Hours)
        btn10Hours.widthAnchor.constraint(equalToConstant: 80).isActive = true
        btn10Hours.heightAnchor.constraint(equalToConstant: 35).isActive = true
        btn10Hours.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        btn10Hours.centerYAnchor.constraint(equalTo: btn5Hour.centerYAnchor, constant: 0.0).isActive = true
        
        
        btn1Day   = UIButton(type: UIButtonType.custom) as UIButton
        btn1Day.tag = 24*60
        btn1Day.setTitle("1 ngày ", for: UIControlState())
        btn1Day.titleLabel!.font =   btn1Day.titleLabel!.font.withSize(15)
        btn1Day.titleLabel!.textAlignment = NSTextAlignment.center
        btn1Day.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btn1Day.titleLabel!.lineBreakMode = .byTruncatingTail
        btn1Day.contentHorizontalAlignment = .center
        btn1Day.contentVerticalAlignment = .center
        btn1Day.contentMode = .scaleToFill
        btn1Day.translatesAutoresizingMaskIntoConstraints = false
        btn1Day.isUserInteractionEnabled = true
        btn1Day.setBackgroundImage( ImageHelper.resize(UIImage(named: "SmallBlueButton2.png")!, newWidth: nil ), for: UIControlState.selected)
        btn1Day.setBackgroundImage( ImageHelper.resize(UIImage(named: "SmallFlatButton2.png")!, newWidth: nil ), for: UIControlState())
        btn1Day.setTitleColor(UIColor.black, for: UIControlState())
        btn1Day.setTitleColor(UIColor.white, for: .selected)
        self.addSubview(btn1Day)
        btn1Day.widthAnchor.constraint(equalToConstant: 80).isActive = true
        btn1Day.heightAnchor.constraint(equalToConstant: 35).isActive = true
        btn1Day.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -17.0).isActive = true
        btn1Day.centerYAnchor.constraint(equalTo: btn5Hour.centerYAnchor, constant: 0.0).isActive = true
        
        
        
        lblNotification = UILabel(frame: CGRect(x: 0,y: 0,width: 200,height: 30))
        lblNotification.text = ""
        lblNotification.font = lblNotification.font.withSize(17)
        lblNotification.textColor = UIColor.black
        lblNotification.textAlignment = NSTextAlignment.center
        lblNotification.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lblNotification)
        lblNotification.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -50).isActive = true
        lblNotification.heightAnchor.constraint(equalToConstant: 50).isActive = true
        lblNotification.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        lblNotification.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:  -50).isActive = true
        
        
        // Bottom  Button Area
        pnlButtonArea = UIView()
        pnlButtonArea.translatesAutoresizingMaskIntoConstraints = false
        pnlButtonArea.isUserInteractionEnabled = true        
        
        // btnCancel Button
        let imgCanelButton = ImageHelper.resize(UIImage(named: "SmallYellowButton.png")!, newWidth: nil)
        btnCancel   = UIButton(type: UIButtonType.custom) as UIButton
        btnCancel.setTitle("HỦY ", for: UIControlState())
        btnCancel.setBackgroundImage(imgCanelButton, for: UIControlState())
        btnCancel.titleLabel!.font =   btnCancel.titleLabel!.font.withSize(15)
        btnCancel.titleLabel!.textAlignment = NSTextAlignment.center
        btnCancel.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btnCancel.titleLabel!.lineBreakMode = .byTruncatingTail
        btnCancel.contentHorizontalAlignment = .center
        btnCancel.contentVerticalAlignment = .center
        btnCancel.contentMode = .scaleToFill
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        btnCancel.isUserInteractionEnabled = true
        
        // Apply Button
        let imgApplyButton = ImageHelper.resize(UIImage(named: "SmallBlueButton.png")!, newWidth: nil)
        btnApply   = UIButton(type: UIButtonType.custom) as UIButton
        btnApply.setTitle("CHỌN", for: UIControlState())
        btnApply.setBackgroundImage(imgApplyButton, for: UIControlState())
        btnApply.titleLabel!.font =   btnApply.titleLabel!.font.withSize(15)
        btnApply.titleLabel!.textAlignment = NSTextAlignment.center
        btnApply.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btnApply.titleLabel!.lineBreakMode = .byTruncatingTail
        btnApply.contentHorizontalAlignment = .center
        btnApply.contentVerticalAlignment = .center
        btnApply.contentMode = .scaleToFill
        btnApply.translatesAutoresizingMaskIntoConstraints = false
        btnApply.isUserInteractionEnabled = true

        
        self.addSubview(pnlButtonArea)
        pnlButtonArea.widthAnchor.constraint(equalTo: self.widthAnchor , constant : -50.0).isActive = true
        pnlButtonArea.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        pnlButtonArea.bottomAnchor.constraint(equalTo: lblNotification.topAnchor, constant: 0.0).isActive = true
        pnlButtonArea.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        pnlButtonArea.addSubview(btnCancel)
        btnCancel.widthAnchor.constraint(equalTo: pnlButtonArea.widthAnchor, multiplier: 0.49).isActive = true
        btnCancel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnCancel.leftAnchor.constraint(equalTo: pnlButtonArea.leftAnchor, constant: 0.0).isActive = true
        btnCancel.topAnchor.constraint(equalTo: pnlButtonArea.topAnchor, constant: 0.0).isActive = true
        
        pnlButtonArea.addSubview(btnApply)
        btnApply.widthAnchor.constraint(equalTo: pnlButtonArea.widthAnchor, multiplier: 0.49).isActive = true
        btnApply.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnApply.rightAnchor.constraint(equalTo: pnlButtonArea.rightAnchor, constant: 0.0).isActive = true
        btnApply.centerYAnchor.constraint(equalTo: btnCancel.centerYAnchor, constant: 0.0).isActive = true
        
        datePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 0, y: 50, width: self.frame.width, height: 200)
        datePicker.timeZone = TimeZone.autoupdatingCurrent
        // datePicker.backgroundColor = UIColor.whiteColor()
        //  datePicker.layer.cornerRadius = 5.0
        //   datePicker.layer.shadowOpacity = 0.5
        datePicker.addTarget(self, action: #selector(PopupDatePicker.onDidChangeDate(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(datePicker)
        datePicker.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -50).isActive = true
        //datePicker.heightAnchor.constraintEqualToAnchor(self.heightAnchor, multiplier: 0.5).active = true
        datePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
       // datePicker.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor, constant: -50.0).active = true
        datePicker.topAnchor.constraint(equalTo: btn1Day.bottomAnchor, constant: 5.0).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: pnlButtonArea.topAnchor, constant: -5.0).isActive = true
        
        

        
        btnCancel.addTarget(self, action: #selector(PopupDatePicker.btnCancel_Clicked(_:)), for:.touchUpInside)
        btnApply.addTarget(self, action: #selector(PopupDatePicker.btnApply_Clicked(_:)), for:.touchUpInside)

        
        
        btn30Minute.addTarget(self, action: #selector(PopupDatePicker.btnMinute_Clicked(_:)), for:.touchUpInside)
        btn1Hour.addTarget(self, action: #selector(PopupDatePicker.btnMinute_Clicked(_:)), for:.touchUpInside)
        btn2Hour.addTarget(self, action: #selector(PopupDatePicker.btnMinute_Clicked(_:)), for:.touchUpInside)
        btn5Hour.addTarget(self, action: #selector(PopupDatePicker.btnMinute_Clicked(_:)), for:.touchUpInside)
        btn10Hours.addTarget(self, action: #selector(PopupDatePicker.btnMinute_Clicked(_:)), for:.touchUpInside)
        btn1Day.addTarget(self, action: #selector(PopupDatePicker.btnMinute_Clicked(_:)), for:.touchUpInside)
        

    }
    
    open func setTitle(_ title: String){
        txtCapTion.text = title
    }
    
    open func setDate(_ date: Date){
        dateValue = date
        datePicker.setDate(date, animated: true)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onDidChangeDateByOnStoryboard(_ sender: UIDatePicker) {
        self.onDidChangeDate(sender)
    }
    
    // called when the date picker called.
    internal func onDidChangeDate(_ sender: UIDatePicker){
        
        dateValue = sender.date
        
        
        let elapsedTime = self.dateValue.timeIntervalSince(Date())
        
        if(elapsedTime < 0 ){
            lblNotification.text = "Không chọn thời điểm quá khứ !"
        } else {
            
            lblNotification.text = ""
        }
        
        self.invalidateButtons()
    }
    
    func invalidateButtons(){
        
        let seconds = dateValue.timeIntervalSince(Date())
        let minutes =  Int(seconds / 60)
        
        self.btn30Minute.isSelected = (minutes == 30) || (minutes == 29)
        self.btn1Hour.isSelected = (minutes == 60) || (minutes == 59)
        self.btn2Hour.isSelected = (minutes == 60*2) || (minutes == 119)
        self.btn5Hour.isSelected = (minutes == 60*5) || (minutes == 299)
        self.btn10Hours.isSelected = (minutes == 60*10) || (minutes == 599)
        self.btn1Day.isSelected = (minutes == 60*24) || (minutes == 1439)

        datePicker.date = dateValue
    }
    
    @IBAction open func btnCancel_Clicked(_ sender: UIButton) {
        
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        self.isCancel = true
                                        self.removeFromSuperview()
                                        self.delegate?.didChooseDateTime(self)
                                    }) 
                                    
        })
        

        
    }
    
    
    @IBAction open func btnApply_Clicked(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        self.dateValue = self.datePicker.date
                                        let elapsedTime = self.dateValue.timeIntervalSince(Date())
                                        
                                        if(elapsedTime < 0 && abs(elapsedTime) > 60 ){
                                            self.lblNotification.text = "Không chọn thời điểm quá khứ !"
                                        } else {
                                            
                                            self.lblNotification.text = ""
                                            
                                            self.isCancel = false
                                            self.removeFromSuperview()
                                            self.delegate?.didChooseDateTime(self)
                                        }

                                    }) 
                                    
        })
        
    }
    
    
    func selectButton(_ sender: UIButton){
        
        self.btn30Minute.isSelected = false
        self.btn1Hour.isSelected = false
        self.btn2Hour.isSelected = false
        self.btn5Hour.isSelected = false
        self.btn10Hours.isSelected = false
        self.btn1Day.isSelected = false
        
        sender.isSelected = true
        datePicker.date = Date().addingTimeInterval(60*Double(sender.tag))
        
    }
    
    @IBAction open func btnMinute_Clicked(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        self.selectButton(sender)
                                        
                                    }) 
                                    
        })
    }
    
    
}
