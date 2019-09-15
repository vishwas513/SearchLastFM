//
//  UIColor.swift
//  LastFmSearch
//
//  Created by Vishwas Mukund on 9/14/19.
//  Copyright © 2019 Vishwas Mukund. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
    static func hexToColor(hexString: String, alpha: CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(UIColor.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    static let negativeMedicine: UIColor = .hexToColor(hexString: "#AE2746")
    static let graphGreen: UIColor = .hexToColor(hexString: "#27AE60")
    static let transparentBlue: UIColor = .hexToColor(hexString: "#6EA8DB", alpha: 0.75)
    static let approveGreen: UIColor = .hexToColor(hexString: "#64FF7D")
    static let softGray: UIColor = .hexToColor(hexString: "#8E8E93")
    static let cellGray: UIColor = .hexToColor(hexString: "#FFFFFF")
    static let medicalCityBlue: UIColor = .hexToColor(hexString: "#0C233F")
    static let medicalCityRed: UIColor = .hexToColor(hexString: "#CF0A2C")
    //static let backgroundGray: UIColor = .hexToColor(hexString: "#D8D8D6")
    static let backgroundGray: UIColor = .hexToColor(hexString: "#F5F9FC")
    static let collectionViewCellBorderGray: UIColor = .hexToColor(hexString: "#979797")
    static let shadowBlack: UIColor = .hexToColor(hexString: "#000000", alpha: 0.5)
    static let hyperLinkBlue: UIColor = .hexToColor(hexString: "#00558C")
    static let detailGray: UIColor = .hexToColor(hexString: "#8C8C8C")
    static let iconGray: UIColor = .hexToColor(hexString: "#7995A3")
    static let featherBlue: UIColor = .hexToColor(hexString: "#B1BFCC")
    static let gradientStartPointBlue: UIColor = .hexToColor(hexString: "#002343")
    static let gradientEndPointBlue: UIColor = .hexToColor(hexString: "#014076")
    static let progressTrackGray: UIColor = .hexToColor(hexString: "#D8D8D8")
    static let gradientGreenStart: UIColor = .hexToColor(hexString: "#285C4D")
    static let gradientGreenEnd: UIColor = .hexToColor(hexString: "#599662")
    static let gradientRedStart: UIColor = .hexToColor(hexString: "#CE2130")
    static let gradientRedEnd: UIColor = .hexToColor(hexString: "#971B2F")
    static let healthPlanLabels: UIColor = .hexToColor(hexString: "#495560")
    static let veryLightGray: UIColor = .hexToColor(hexString: "#F4F4F4")
    static let accentBlue: UIColor = .hexToColor(hexString: "#6EA8DB")
    static let upgradeBlue: UIColor = .hexToColor(hexString: "#0B223E")
    static let buttonBlue: UIColor = .hexToColor(hexString: "#3870C6")
    static let warningLabelBlue: UIColor = .hexToColor(hexString: "#E9F3FD")
    static let lightYellowForBanner: UIColor = .hexToColor(hexString: "#FFFFC7")
    static let lightYellowForBannerBackground: UIColor = .hexToColor(hexString: "#FFFF94")
    static let robinGreen: UIColor = .hexToColor(hexString: "#00CEC9")
    
    static let descriptionBackgroundGreen: UIColor = .hexToColor(hexString: "#E9F9F0")
    
    static let descriptionBorderGreen: UIColor = .hexToColor(hexString: "#24CC6D")
    
    static let textGreen: UIColor = .hexToColor(hexString: "#10572F")
    static let systolicColor = UIColor.graphGreen
    static let diastolicColor = UIColor.accentBlue
    
}

