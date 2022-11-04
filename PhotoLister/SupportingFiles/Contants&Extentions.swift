//
//  Contants.swift
//  PhotoLister
//
//  Created by Trident on 02/11/22.
//

import Foundation
import UIKit
import CoreGraphics

// NSLocalizedString
let Postic = NSLocalizedString("Postic", comment: "")
let ViewPost = NSLocalizedString("View Post", comment: "")
let Comments = NSLocalizedString("Comments", comment: "")
let Back = NSLocalizedString("Back", comment: "")
let Posts = NSLocalizedString("Posts", comment: "")
let NoNetworkCoverageOfflineMode = NSLocalizedString("No network Coverage, Offline mode.", comment: "")
let Warning = NSLocalizedString("Warning", comment: "")
let OK = NSLocalizedString("OK", comment: "")
let Home = NSLocalizedString("Home", comment: "")
let User = NSLocalizedString("User", comment: "")
let Create = NSLocalizedString("Create", comment: "")
let Account = NSLocalizedString("Account", comment: "")
let All = NSLocalizedString("All", comment: "")
let MostRecent = NSLocalizedString("Most Recent", comment: "")
let History = NSLocalizedString("History", comment: "")
let Favourites = NSLocalizedString("Favourites", comment: "")
let Trash = NSLocalizedString("Trash", comment: "")
let CompanyStr = NSLocalizedString("Company", comment: "")
let AFewSecondsAgo = NSLocalizedString("a few seconds ago", comment: "")

// Constant String
let EmptyStr = ""
let comma = ","

// Constant Image
let LogoImage = "LogoImage"

// System Images
let PhotoCircleSysImg = "photo.circle"
let BellSysImg = "bell"
let MagnifyingGlassSysImg = "magnifyingglass"
let MCircleFillSysImg = "m.circle.fill"
let HouseCircleSysImg = "house.circle"
let PersonTwoSysImg = "person.2"
let PlusCircleSysImg = "plus.circle"
let LineThreeHorizontalSysImg = "line.3.horizontal"
let PhotoOnRectangleAngledSysImg = "photo.on.rectangle.angled"
let EnvelopeSysImg = "envelope"
let PhoneSysImg = "phone"
let NetworkSysImg = "network"
let HouseSysImg = "house"
let BuildingColumnsSysImg = "building.columns"
let ChevronBackwardSysImg = "chevron.backward"
let ArrowTriangleTwoCirclePathSysImg = "arrow.triangle.2.circlepath"
let MessageSysImg = "message"

// CGFloat
let zero = CGFloat(0)
let one = CGFloat(1)
let five = CGFloat(5)
let ten = CGFloat(10)
let fifteen = CGFloat(15)
let zeroPtFive = CGFloat(0.5)
let twenty = CGFloat(20)
let twentyFive = CGFloat(25)
let thirty = CGFloat(30)
let forty = CGFloat(40)
let fifty = CGFloat(50)
let sixty = CGFloat(60)

// Font
let InterRegular = "Inter-Regular"
let InterBold = "Inter-Bold"
let InterItalic = "Inter-Italic"

// UIFont
func textSize(textStyle: UIFont.TextStyle) -> CGFloat {
   return UIFont.preferredFont(forTextStyle: textStyle).pointSize
}

@objc public class UserDefaultsStore:NSObject {

//  Here we store the bool value, when last sync happened
    private static var saveSyncTime = "saveSyncTime"

 public static var saveRefreshDate: Date? {
     get {
        return UserDefaults.standard.object(forKey: saveSyncTime) as? Date
     }
     set {
         if newValue != nil {
             UserDefaults.standard.set(newValue, forKey: saveSyncTime)
         } else {
             UserDefaults.standard.removeObject(forKey: saveSyncTime)
         }
     }
  }
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
