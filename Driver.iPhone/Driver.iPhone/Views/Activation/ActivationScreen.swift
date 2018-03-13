//
//  ActivationViewController.swift
//  Driver.iPhone
//
//  Created by Trung Dao on 6/15/16.
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
import SClientModelControllers

open class ActivationScreen: UIViewController,UITextFieldDelegate{
    
    var lblTitle: UILabel!
    var txtCitizenID: UITextField!
    var txtActivationCode: UITextField!
    var btnGetCode: UIButton!
    var btnCancel: UIButton!
    var btnCommitCode: UIButton!
    var lblStatus: UILabel!
    var currentRequestID: String?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.initControls()
        
    }
    
    
    func initControls(){
        
        let scrRect = UIScreen.main.bounds
        
        lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        lblTitle.text = "XÁC NHẬN TÀI KHOẢN"
        lblTitle.textColor = UIColor.black
        lblTitle.textAlignment = NSTextAlignment.center
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblTitle)
        lblTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        lblTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60.0).isActive = true
        
        
        txtCitizenID = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        txtCitizenID.placeholder = "Chứng minh nhân dân"
        txtCitizenID.font = UIFont.systemFont(ofSize: 18)
        txtCitizenID.borderStyle = UITextBorderStyle.none
        txtCitizenID.autocorrectionType = UITextAutocorrectionType.no
        txtCitizenID.keyboardType = UIKeyboardType.phonePad
        txtCitizenID.returnKeyType = UIReturnKeyType.continue
        txtCitizenID.clearButtonMode = UITextFieldViewMode.whileEditing;
        txtCitizenID.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        txtCitizenID.translatesAutoresizingMaskIntoConstraints = false
        txtCitizenID.textAlignment = .center
        txtCitizenID.delegate = self
        self.view.addSubview(txtCitizenID)
        txtCitizenID.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        txtCitizenID.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 40.0).isActive = true
        txtCitizenID.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        txtCitizenID.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        
        
        txtActivationCode = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        txtActivationCode.placeholder = "Nhập mã xác nhận"
        txtActivationCode.font = UIFont.systemFont(ofSize: 15)
        txtActivationCode.borderStyle = UITextBorderStyle.none
        txtActivationCode.autocorrectionType = UITextAutocorrectionType.no
        txtActivationCode.keyboardType = UIKeyboardType.numberPad
        txtActivationCode.returnKeyType = UIReturnKeyType.continue
        txtActivationCode.clearButtonMode = UITextFieldViewMode.whileEditing;
        txtActivationCode.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        txtActivationCode.translatesAutoresizingMaskIntoConstraints = false
        txtActivationCode.textAlignment = .center
        txtActivationCode.delegate = self
        txtActivationCode.isHidden = true
        self.view.addSubview(txtActivationCode)
        txtActivationCode.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        txtActivationCode.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 40.0).isActive = true
        txtActivationCode.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        txtActivationCode.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        
        let line1 = CAShapeLayer()
        line1.fillColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 0.7).cgColor
        line1.path = UIBezierPath(roundedRect: CGRect(x: scrRect.width*0.1, y: 165  , width: scrRect.width * 0.8, height: 1), cornerRadius: 0).cgPath
        self.view.layer.addSublayer(line1)

        // Quick Order Button
        let imgButton = ImageHelper.resize(UIImage(named: "BlueButton.png")!, newWidth: scrRect.width/2)
        btnGetCode   = UIButton(type: UIButtonType.custom) as UIButton
        btnGetCode.setTitle("GỬI MÃ XÁC NHẬN", for: UIControlState())
        btnGetCode.setBackgroundImage(imgButton, for: UIControlState())
        btnGetCode.titleLabel!.font =   btnGetCode.titleLabel!.font.withSize(15)
        btnGetCode.titleLabel!.textAlignment = NSTextAlignment.center
        btnGetCode.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btnGetCode.titleLabel!.lineBreakMode = .byTruncatingTail
        btnGetCode.contentHorizontalAlignment = .center
        btnGetCode.contentVerticalAlignment = .center
        btnGetCode.contentMode = .scaleToFill
        btnGetCode.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnGetCode)
        btnGetCode.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        btnGetCode.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnGetCode.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        btnGetCode.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -300.0).isActive = true
        
        
        
        // Quick Order Button
        let imgBlueButton = ImageHelper.resize(UIImage(named: "SmallPurpleButton.png")!, newWidth: scrRect.width/4.5)
        btnCancel   = UIButton(type: UIButtonType.custom) as UIButton
        btnCancel.setTitle("LÀM LẠI", for: UIControlState())
        btnCancel.setBackgroundImage(imgButton, for: UIControlState())
        btnCancel.titleLabel!.font =   btnCancel.titleLabel!.font.withSize(15)
        btnCancel.titleLabel!.textAlignment = NSTextAlignment.center
        btnCancel.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btnCancel.titleLabel!.lineBreakMode = .byTruncatingTail
        btnCancel.contentHorizontalAlignment = .center
        btnCancel.contentVerticalAlignment = .center
        btnCancel.contentMode = .scaleToFill
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        btnCancel.isHidden = true
        
        self.view.addSubview(btnCancel)
        btnCancel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.45).isActive = true
        btnCancel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnCancel.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -5).isActive = true
        btnCancel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -300.0).isActive = true
        
        
        
        // Quick Order Button
        let imgOrangeButton = ImageHelper.resize(UIImage(named: "SmallOrangeButton.png")!, newWidth: scrRect.width/4.5)
        btnCommitCode   = UIButton(type: UIButtonType.custom) as UIButton
        btnCommitCode.setTitle("XÁC NHẬN", for: UIControlState())
        btnCommitCode.setBackgroundImage(imgOrangeButton, for: UIControlState())
        btnCommitCode.titleLabel!.font =   btnCommitCode.titleLabel!.font.withSize(15)
        btnCommitCode.titleLabel!.textAlignment = NSTextAlignment.center
        btnCommitCode.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btnCommitCode.titleLabel!.lineBreakMode = .byTruncatingTail
        btnCommitCode.contentHorizontalAlignment = .center
        btnCommitCode.contentVerticalAlignment = .center
        btnCommitCode.contentMode = .scaleToFill
        btnCommitCode.translatesAutoresizingMaskIntoConstraints = false
        btnCommitCode.isHidden = true
        self.view.addSubview(btnCommitCode)
        btnCommitCode.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.45).isActive = true
        btnCommitCode.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnCommitCode.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 5.0).isActive = true
        btnCommitCode.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -300.0).isActive = true
        
        
        
        
        lblStatus = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblStatus.font = lblStatus.font.withSize(12)
        lblStatus.text = "Mã xác nhận sẽ được gửi đến số điện thoại của bạn."
        lblStatus.textColor = UIColor.darkGray
        lblStatus.textAlignment = NSTextAlignment.center
        lblStatus.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblStatus)
        lblStatus.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        lblStatus.bottomAnchor.constraint(equalTo: btnCommitCode.topAnchor, constant: -50.0).isActive = true
        
        
        
        btnGetCode.addTarget(self, action: #selector(ActivationScreen.btnGetCode_Clicked(_:)), for:.touchUpInside)
        btnCommitCode.addTarget(self, action: #selector(ActivationScreen.btnCommitCode_Clicked(_:)), for:.touchUpInside)
        btnCancel.addTarget(self, action: #selector(ActivationScreen.btnCancel_Clicked(_:)), for:.touchUpInside)
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ActivationScreen.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        txtCitizenID.becomeFirstResponder()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction open func btnGetCode_Clicked(_ sender: UIButton) {
        
        self.txtCitizenID.endEditing(true)
        self.txtActivationCode.endEditing(true)
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    self.btnGetCode.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.btnGetCode.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        
                                        let CitizenID = self.txtCitizenID.text!.trimmingCharacters(
                                            in: CharacterSet.whitespacesAndNewlines
                                        )
                                        
                                        if(CitizenID != "" ){
                                            
                                              DriverController.RequestForActivationCode(CitizenID, countryCode: "VN", completion: { (requestId, errorcode) in
                                            
                                                    if(requestId != nil){
                                                        self.currentRequestID = requestId
                                                        self.lblStatus.text = "Đã gửi mã kích hoạt đến số điện thoại của bạn."
                                                        self.btnGetCode.isHidden = true
                                                        self.btnCancel.isHidden = false
                                                        self.btnCommitCode.isHidden = false
                                                        self.txtActivationCode.text = ""
                                                        self.txtActivationCode.isHidden = false
                                                        self.txtCitizenID.isHidden = true
                                                        self.txtActivationCode.becomeFirstResponder()

                                                    }else{
                                                        
                                                        if(errorcode == "WrongCitizenID"){
                                                            self.lblStatus.text = "Tài khoản chưa được đăng ký, vui lòng kiểm tra lại."
                                                    
                                                        }else{                          
                                                            self.lblStatus.text = "Gửi mã kích hoạt không thành công."
                                                        }
                                                    }
                                                
                                            })
                                            
                                        }else{
                                            self.lblStatus.text = "Vui lòng nhập số điện thoại của bạn."
                                        }
                                    }) 
                                    
        })
    }
    
    @IBAction open func btnCommitCode_Clicked(_ sender: UIButton) {
        
        self.txtCitizenID.endEditing(true)
        self.txtActivationCode.endEditing(true)
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    self.btnCommitCode.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.btnCommitCode.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        if(self.currentRequestID != nil){
                                            
                                            self.lblStatus.text = "Đang kiểm tra mã kích hoạt..."
                                            
                                            
                                            let CitizenID = self.txtCitizenID.text!.trimmingCharacters(
                                                in: CharacterSet.whitespacesAndNewlines
                                            )
                                            
                                            let activateCode = self.txtActivationCode.text!.trimmingCharacters(
                                                in: CharacterSet.whitespacesAndNewlines
                                            )
                                            
                                            
                                            DriverController.CheckForActivationCode(self.currentRequestID!, code: activateCode, CitizenID: CitizenID) { (DriverId, errorcode) in
                                                
                                                                if(DriverId == nil){
                                                                    if(errorcode == "WrongCitizenID"){
                                                                        self.lblStatus.text = "Tài khoản chưa được đăng ký, vui lòng kiểm tra lại."
                                                                    }else{
                                                                        self.lblStatus.text = "Mã kích hoạt không đúng, vui lòng kiểm tra lại!"
                                                                    }
                                                                    return
                                                                }
                                                                SCONNECTING.DriverManager!.login(DriverId!, completion: { (success, setting) in
                                                                    
                                                                        if(!success){
                                                                            self.lblStatus.text = "Kết nối không hợp lệ."
                                                                            self.btnCommitCode.isHidden = true
                                                                            self.btnCancel.isHidden = false
                                                                            return
                                                                        }
                                                                    
                                                                        self.lblStatus.text = "Kích hoạt thành công. Đang đăng nhập..."
                                                                        self.btnCommitCode.isHidden = true
                                                                        self.btnCancel.isHidden = true
                                         
                                                                        SCONNECTING.DriverManager!.initCurrentDriver { isValidDriver in
                                                                            
                                                                                if(isValidDriver == false){
                                                                                    
                                                                                    AppDelegate.activationWindow = ActivationWindow(frame: UIScreen.main.bounds)
                                                                                    AppDelegate.activationWindow?.makeKeyAndVisible()
                                                                                    
                                                                                }else{
                                                                                    
                                                                                    DriverController.activate(DriverId!){
                                                                                        
                                                                                        SCONNECTING.Start {
                                                                                            
                                                                                            if( AppDelegate.mainWindow  == nil){
                                                                                                AppDelegate.mainWindow = MainWindow(frame: UIScreen.main.bounds)
                                                                                                AppDelegate.mainWindow?.makeKeyAndVisible()
                                                                                            }
                                                                                            
                                                                                        }
                                                                                    }
                                                                                }
                                                                        }
                                                        })
                                                
                                            }
                                        }
                                    }) 
                                    
        })
    }
    
    
    @IBAction open func btnCancel_Clicked(_ sender: UIButton) {
        
        self.txtCitizenID.endEditing(true)
        self.txtActivationCode.endEditing(true)
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    self.btnCancel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.btnCancel.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        self.btnGetCode.isHidden = false
                                        self.btnCancel.isHidden = true
                                        self.btnCommitCode.isHidden = true
                                        self.txtCitizenID.isHidden = false
                                        self.txtActivationCode.isHidden = true
                                        self.txtActivationCode.text = ""
                                        
                                        self.lblStatus.text = "Nhập CMND và nhận Mã kích hoạt được gửi đến số điện thoại của bạn."
                                        
                                    }) 
                                    
        })
    }
    
    func accountActivated(){
        
        
        AppDelegate.mainWindow = MainWindow(frame: UIScreen.main.bounds)
        AppDelegate.mainWindow?.makeKeyAndVisible()
        
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField === txtCitizenID)
        {
            txtCitizenID.resignFirstResponder()
            btnGetCode.becomeFirstResponder()
        }
        
        return true;
    }
    
}
