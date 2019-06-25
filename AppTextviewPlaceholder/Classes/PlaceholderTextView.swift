//
//  PlaceholderTextView.swift
//  Ambatana
//
//  Created by Ignacio Nieto Carvajal on 20/2/15.
//  Copyright (c) 2015 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit

private let PlaceholderInset: CGFloat = 8

@IBDesignable open class AppPlaceholderTextView: UITextView {
    
    @IBInspectable open var placeholder: NSString? { didSet { setNeedsDisplay() } }

    @IBInspectable open var placeholderColor: UIColor = UIColor.lightGray

    @IBInspectable open var borderColor: UIColor = UIColor.clear { didSet { self.layer.borderColor = borderColor.cgColor } }

    @IBInspectable open var borderWidth: CGFloat = 0.0 { didSet { self.layer.borderWidth = borderWidth } }

    @IBInspectable open var cornerRadius: CGFloat = 6.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0.0
        }
    }

    // MARK: - Text insertion methods need to "remove" the placeholder when needed
    
    /** Override normal text string */
    override open var text: String! { didSet { setNeedsDisplay() } }
    
    /** Override attributed text string */
    override open var attributedText: NSAttributedString! { didSet { setNeedsDisplay() } }
    
    /** Setting content inset needs a call to setNeedsDisplay() */
    override open var contentInset: UIEdgeInsets { didSet { setNeedsDisplay() } }
    
    /** Setting font needs a call to setNeedsDisplay() */
    override open var font: UIFont? { didSet { setNeedsDisplay() } }
    
    /** Setting text alignment needs a call to setNeedsDisplay() */
    override open var textAlignment: NSTextAlignment { didSet { setNeedsDisplay() } }

    
    // MARK: Lifecycle
    
    /** Override coder init, for IB/XIB compatibility */
    #if !TARGET_INTERFACE_BUILDER
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addObservers()
    }

    /** Override common init, for manual allocation */
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addObservers()
    }
    #endif

    /** Initializes the placeholder text view, waiting for a notification of text changed */
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(AppPlaceholderTextView.textChangedForPlaceholderTextView(_:)), name:UITextView.textDidChangeNotification , object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(AppPlaceholderTextView.textChangedForPlaceholderTextView(_:)), name: UITextView.textDidBeginEditingNotification, object: self)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    /** willMoveToWindow will get called with a nil argument when the window is about to dissapear */
    override open func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        newWindow == nil ? removeObservers() : addObservers()
    }

    // MARK: - Adjusting placeholder.
    @objc func textChangedForPlaceholderTextView(_ notification: Notification) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // in case we don't have a text, put the placeholder (if any)
        if text.count == 0 && self.placeholder != nil {
            
            let baseRect = placeholderBoundsContainedIn(self.bounds)
            let font = self.font ?? self.typingAttributes[NSAttributedString.Key.paragraphStyle] ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
            
            self.placeholderColor.set()
            
            // build the custom paragraph style for our placeholder text
            var customParagraphStyle: NSMutableParagraphStyle!
            
            if let defaultParagraphStyle =  typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle {
                customParagraphStyle = defaultParagraphStyle.mutableCopy() as! NSMutableParagraphStyle
            } else {
                customParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            }
            
            // set attributes
            customParagraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
            customParagraphStyle.alignment = self.textAlignment
            let attributes = [NSAttributedString.Key.font: font,
                              NSAttributedString.Key.paragraphStyle: customParagraphStyle.copy() as! NSParagraphStyle,
                              NSAttributedString.Key.foregroundColor: self.placeholderColor]
            
            // draw in rect.
            self.placeholder?.draw(in: baseRect, withAttributes: attributes)
        }
    }
    
    func placeholderBoundsContainedIn(_ containerBounds: CGRect) -> CGRect {
        
        // get the base rect with content insets.
        let baseRect = containerBounds.inset(by: UIEdgeInsets(top: PlaceholderInset, left: PlaceholderInset/2.0, bottom: 0, right: 0))
        
        // adjust typing and selection attributes
        if let paragraphStyle = typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle {
            baseRect.offsetBy(dx: paragraphStyle.headIndent, dy: paragraphStyle.firstLineHeadIndent)
        }
        
        return baseRect
    }
}
