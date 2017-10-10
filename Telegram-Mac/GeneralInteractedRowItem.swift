//
//  GeneralInteractedRowItem.swift
//  Telegram-Mac
//
//  Created by keepcoder on 12/10/2016.
//  Copyright © 2016 Telegram. All rights reserved.
//

import Cocoa
import TGUIKit



struct GeneralThumbAdditional {
    let thumb:CGImage
    let textInset:CGFloat?
}


class GeneralInteractedRowItem: GeneralRowItem {
        
    var nameLayout:(TextNodeLayout, TextNode)?
    var nameLayoutSelected:(TextNodeLayout, TextNode)?
    let name:String
    var descLayout:TextViewLayout?
    var nameStyle:ControlStyle
    let thumb:GeneralThumbAdditional?
    let switchAppearance: SwitchViewAppearance
    var nameWidth:CGFloat {
        var width = self.size.width - (inset.left + inset.right)
        switch type {
        case .switchable:
            width -= 40
        case .context:
            width -= 40
        default:
            break
        }
        if let thumb = thumb {
            width -= thumb.thumb.backingSize.width + 20
        }
        return width
    }
    
   
    init(_ initialSize:NSSize, stableId:AnyHashable = arc4random(), name:String, icon: CGImage? = nil, nameStyle:ControlStyle = ControlStyle(font: NSFont.normal(.title), foregroundColor: theme.colors.text), description: String? = nil, type:GeneralInteractedType = .none, action:@escaping ()->Void = {}, drawCustomSeparator:Bool = true, thumb:GeneralThumbAdditional? = nil, border:BorderType = [], inset: NSEdgeInsets = NSEdgeInsets(left: 30.0, right: 30.0), enabled: Bool = true, switchAppearance: SwitchViewAppearance = switchViewAppearance) {
        self.name = name
        if let description = description {
            descLayout = TextViewLayout(.initialize(string: description, color: theme.colors.grayText, font: .normal(.text)))
        } else {
            descLayout = nil
        }
        self.nameStyle = nameStyle
        if thumb == nil, let icon = icon {
            self.thumb = GeneralThumbAdditional(thumb: icon, textInset: nil)
        } else {
            self.thumb = thumb
        }
        self.switchAppearance = switchAppearance
        super.init(initialSize, stableId:stableId, type:type, action:action, drawCustomSeparator:drawCustomSeparator, border:border, inset:inset, enabled: enabled)
    }
    
    override var height: CGFloat {
        if let descLayout = descLayout {
            return super.height + descLayout.layoutSize.height + 5
        }
        return super.height
    }
    
    override func makeSize(_ width: CGFloat, oldWidth:CGFloat) -> Bool {
        
        nameLayout = TextNode.layoutText(maybeNode: nil,  NSAttributedString.initialize(string: name, color: nameStyle.foregroundColor, font: nameStyle.font), nil, 1, .end, NSMakeSize(nameWidth, self.size.height), nil, isSelected, .left)
        nameLayoutSelected = TextNode.layoutText(maybeNode: nil,  NSAttributedString.initialize(string: name, color: .white, font: nameStyle.font), nil, 1, .end, NSMakeSize(nameWidth, self.size.height), nil, isSelected, .left)
        descLayout?.measure(width: nameWidth)
        
        return super.makeSize(width, oldWidth: oldWidth)
    }
    
    override func prepare(_ selected: Bool) {
        super.prepare(selected)
    }
    
    override func viewClass() -> AnyClass {
        return GeneralInteractedRowView.self
    }
    
}
