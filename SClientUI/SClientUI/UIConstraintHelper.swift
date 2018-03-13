//
//  UIContrainstHelper.swift
//  SClientUI
//
//  Created by Trung Dao on 6/20/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation
import UIKit
import SClientData

private var  UIControlKey1 : UInt8 = 2
private var  UIControlKey2 : UInt8 = 1

extension UIView {
    
    public var constraintObject: ConstraintObject {
        get {return ExHelper.getter(self, key: &UIControlKey1){ return ConstraintObject(parent: self) }}
        set { ExHelper.setter(self, key: &UIControlKey1, value: newValue) }
    }
    
    public func getHeightConstant() -> CGFloat{
        if(constraintObject.heightConstraint != nil){
            return constraintObject.heightConstraint!.constant
        }else{
            return self.frame.size.height
        }
    }
    public func initHeightConstraints(_ heightDefault: CGFloat?, related: NSLayoutDimension?, second: CGFloat?, third: CGFloat?, fourth: CGFloat?){
        
        if(heightDefault != nil){
            constraintObject.height = heightDefault
            
            if(related != nil){
                constraintObject.heightConstraint = self.heightAnchor.constraint(equalTo: related!, constant: heightDefault!)
            }else{
                constraintObject.heightConstraint = self.heightAnchor.constraint(equalToConstant: heightDefault!)
            }

            constraintObject.heightConstraint?.isActive = true
        }
        
        if(second != nil){
            constraintObject.heightSecond = second
        }
        if(third != nil){
            constraintObject.heightThird = third
        }
        
        if(fourth != nil){
            constraintObject.heightFourth = fourth
        }

        
    }
    
    
    
    public func initWidthConstraints(_ widthDefault: CGFloat?, related: NSLayoutDimension?, second: CGFloat?, third: CGFloat?, fourth: CGFloat?){
        
        if(widthDefault != nil){
            constraintObject.width = widthDefault
                    
            if(related != nil){
                constraintObject.widthConstraint = self.widthAnchor.constraint(equalTo: related!, constant: widthDefault!)
            }else{
                constraintObject.widthConstraint = self.widthAnchor.constraint(equalToConstant: widthDefault!)
            }
            constraintObject.widthConstraint?.isActive = true
        }
        
        if(second != nil){
            constraintObject.widthSecond = second
        }
        if(third != nil){
            constraintObject.widthThird = third
        }
        
        if(fourth != nil){
            constraintObject.widthFourth = fourth
        }
        
    }
    
    
    public func initTopConstraints(_ topDefault: CGFloat?, related: NSLayoutYAxisAnchor, second: CGFloat?, third: CGFloat?, fourth: CGFloat?){
        
        if(topDefault != nil){
            constraintObject.top = topDefault
           
            constraintObject.topConstraint = self.topAnchor.constraint(equalTo: related, constant: topDefault!)
            
            constraintObject.topConstraint?.isActive = true
        }
        
        
        if(second != nil){
            constraintObject.topSecond = second
        }
        if(third != nil){
            constraintObject.topThird = third
        }
        
        if(fourth != nil){
            constraintObject.topFourth = fourth
        }
        
    }

    
    public func initBottomConstraints(_ bottomDefault: CGFloat?, related: NSLayoutYAxisAnchor, second: CGFloat?, third: CGFloat?, fourth: CGFloat?){
        
        if(bottomDefault != nil){
            constraintObject.bottom = bottomDefault
            constraintObject.bottomConstraint = self.bottomAnchor.constraint(equalTo: related, constant: bottomDefault!)
            constraintObject.bottomConstraint?.isActive = true
        }
        
        if(second != nil){
            constraintObject.bottomSecond = second
        }
        if(third != nil){
            constraintObject.bottomThird = third
        }
        
        if(fourth != nil){
            constraintObject.bottomFourth = fourth
        }
    }
    
    
    
    public func initLeftConstraints(_ leftDefault: CGFloat?, related: NSLayoutXAxisAnchor, second: CGFloat?, third: CGFloat?, fourth: CGFloat?){
        
        if(leftDefault != nil){
            constraintObject.left = leftDefault
            constraintObject.leftConstraint = self.leftAnchor.constraint(equalTo: related, constant: leftDefault!)
            constraintObject.leftConstraint?.isActive = true
        }
        
        if(second != nil){
            constraintObject.leftSecond = second
        }
        if(third != nil){
            constraintObject.leftThird = third
        }
        
        if(fourth != nil){
            constraintObject.leftFourth = fourth
        }
        
    }
    
    
    
    public func initRightConstraints(_ rightDefault: CGFloat?, related: NSLayoutXAxisAnchor, second: CGFloat?, third: CGFloat?, fourth: CGFloat?){
        
        if(rightDefault != nil){
            constraintObject.right = rightDefault
            constraintObject.rightConstraint = self.rightAnchor.constraint(equalTo: related, constant: rightDefault!)
            constraintObject.rightConstraint?.isActive = true
        }
        
        if(second != nil){
            constraintObject.rightSecond = second
        }
        if(third != nil){
            constraintObject.rightThird = third
        }
        
        if(fourth != nil){
            constraintObject.rightFourth = fourth
        }
        
        
    }


    
    public var showControl : Bool{
        
         get {
            
             return !self.isHidden
        }
        
        set {
            
            self.isHidden = !newValue
            self.invalidateState()
        }

        
    }
    
    
    public var ConstraintState : Int{
        
        get {
            return constraintObject.currentState
        }
        
        set {
            
            if(constraintObject.currentState != newValue){
                    constraintObject.preState =  constraintObject.currentState
                    constraintObject.currentState = newValue                
            }
              self.invalidateState()
        }
        
    }
    
    func invalidateState(){
        
        if(constraintObject.heightConstraint  != nil){
            
            if(self.isHidden == true){
                constraintObject.heightConstraint!.constant = 0
                
            }else if(constraintObject.currentState == 1 && constraintObject.height != nil){
                 constraintObject.heightConstraint!.constant = constraintObject.height!
            
            }else if(constraintObject.currentState == 2 && constraintObject.heightSecond != nil){
                constraintObject.heightConstraint!.constant = constraintObject.heightSecond!
                
            }else if(constraintObject.currentState == 3 && constraintObject.heightThird != nil){
                constraintObject.heightConstraint!.constant = constraintObject.heightThird!
                
            }else if(constraintObject.currentState == 4 && constraintObject.heightFourth != nil){
                constraintObject.heightConstraint!.constant = constraintObject.heightFourth!
            }
            
        }
        
        if(constraintObject.widthConstraint  != nil){
            
            if(self.isHidden == true){
                constraintObject.widthConstraint!.constant = 0
                
            }else if(constraintObject.currentState == 1 && constraintObject.width != nil){
                constraintObject.widthConstraint!.constant = constraintObject.width!
                
            }else if(constraintObject.currentState == 2 && constraintObject.widthSecond != nil){
                constraintObject.widthConstraint!.constant = constraintObject.widthSecond!
                
            }else if(constraintObject.currentState == 3 && constraintObject.widthThird != nil){
                constraintObject.widthConstraint!.constant = constraintObject.widthThird!
                
            }else if(constraintObject.currentState == 4 && constraintObject.widthFourth != nil){
                constraintObject.widthConstraint!.constant = constraintObject.widthFourth!
            }
            
        }

        
        if(constraintObject.topConstraint  != nil){
            
            if(self.isHidden == true){
                constraintObject.topConstraint!.constant = 0
                
            }else if(constraintObject.currentState == 1 && constraintObject.top != nil){
                constraintObject.topConstraint!.constant = constraintObject.top!
                
            }else if(constraintObject.currentState == 2 && constraintObject.topSecond != nil){
                constraintObject.topConstraint!.constant = constraintObject.topSecond!
                
            }else if(constraintObject.currentState == 3 && constraintObject.topThird != nil){
                constraintObject.topConstraint!.constant = constraintObject.topThird!
                
            }else if(constraintObject.currentState == 4 && constraintObject.topFourth != nil){
                constraintObject.topConstraint!.constant = constraintObject.topFourth!
            }
            
        }

        
        if(constraintObject.bottomConstraint  != nil){
            
            if(self.isHidden == true){
                constraintObject.bottomConstraint!.constant = 0
                
            }else if(constraintObject.currentState == 1 && constraintObject.bottom != nil){
                constraintObject.bottomConstraint!.constant = constraintObject.bottom!
                
            }else if(constraintObject.currentState == 2 && constraintObject.bottomSecond != nil){
                constraintObject.bottomConstraint!.constant = constraintObject.bottomSecond!
                
            }else if(constraintObject.currentState == 3 && constraintObject.bottomThird != nil){
                constraintObject.bottomConstraint!.constant = constraintObject.bottomThird!
                
            }else if(constraintObject.currentState == 4 && constraintObject.bottomFourth != nil){
                constraintObject.bottomConstraint!.constant = constraintObject.bottomFourth!
            }
            
        }
        
        if(constraintObject.leftConstraint  != nil){
            
            if(self.isHidden == true){
                constraintObject.leftConstraint!.constant = 0
                
            }else if(constraintObject.currentState == 1 && constraintObject.left != nil){
                constraintObject.leftConstraint!.constant = constraintObject.left!
                
            }else if(constraintObject.currentState == 2 && constraintObject.leftSecond != nil){
                constraintObject.leftConstraint!.constant = constraintObject.leftSecond!
                
            }else if(constraintObject.currentState == 3 && constraintObject.leftThird != nil){
                constraintObject.leftConstraint!.constant = constraintObject.leftThird!
                
            }else if(constraintObject.currentState == 4 && constraintObject.leftFourth != nil){
                constraintObject.leftConstraint!.constant = constraintObject.leftFourth!
            }
            
        }
        
        
        if(constraintObject.rightConstraint  != nil){
            
            if(self.isHidden == true){
                constraintObject.rightConstraint!.constant = 0
                
            }else if(constraintObject.currentState == 1 && constraintObject.right != nil){
                constraintObject.rightConstraint!.constant = constraintObject.right!
                
            }else if(constraintObject.currentState == 2 && constraintObject.rightSecond != nil){
                constraintObject.rightConstraint!.constant = constraintObject.rightSecond!
                
            }else if(constraintObject.currentState == 3 && constraintObject.rightThird != nil){
                constraintObject.rightConstraint!.constant = constraintObject.rightThird!
                
            }else if(constraintObject.currentState == 4 && constraintObject.rightFourth != nil){
                constraintObject.rightConstraint!.constant = constraintObject.rightFourth!
            }
            
        }

        
    }


}


open class ConstraintObject{
    
    var parent: UIView
    
    open var height: CGFloat?
    open var width: CGFloat?
    open var top: CGFloat?
    open var bottom: CGFloat?
    open var left: CGFloat?
    open var right: CGFloat?

    open var heightSecond: CGFloat?
    open var heightThird: CGFloat?
    open var heightFourth: CGFloat?
    open var heightConstraint: NSLayoutConstraint?
    
    open var widthSecond: CGFloat?
    open var widthThird: CGFloat?
    open var widthFourth: CGFloat?
    open var widthConstraint: NSLayoutConstraint?
    
    open var topSecond: CGFloat?
    open var topThird: CGFloat?
    open var topFourth: CGFloat?
    open var topConstraint: NSLayoutConstraint?
    
    open var bottomSecond: CGFloat?
    open var bottomThird: CGFloat?
    open var bottomFourth: CGFloat?
    open var bottomConstraint: NSLayoutConstraint?
    
    open var leftSecond: CGFloat?
    open var leftThird: CGFloat?
    open var leftFourth: CGFloat?
    open var leftConstraint: NSLayoutConstraint?
    
    open var rightSecond: CGFloat?
    open var rightThird: CGFloat?
    open var rightFourth: CGFloat?
    open var rightConstraint: NSLayoutConstraint?
    
    open var preState: Int = 1
    open var currentState: Int = 1

    
    public init(parent: UIView){
        
        self.parent = parent
    }

    
    
}
