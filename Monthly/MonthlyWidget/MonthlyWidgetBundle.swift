//
//  MonthlyWidgetBundle.swift
//  MonthlyWidget
//
//  Created by admin on 25/11/2025.
//

import WidgetKit
import SwiftUI

@main
struct MonthlyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MonthlyWidget()
        MonthlyWidgetControl()
        MonthlyWidgetLiveActivity()
    }
}
