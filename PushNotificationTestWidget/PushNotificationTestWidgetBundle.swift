//
//  PushNotificationTestWidgetBundle.swift
//  PushNotificationTestWidget
//
//  Created by Riku Yamamoto on 2024/04/14.
//

import WidgetKit
import SwiftUI

@main
struct PushNotificationTestWidgetBundle: WidgetBundle {
    var body: some Widget {
        PushNotificationTestWidget()
        PushNotificationTestWidgetLiveActivity()
    }
}
