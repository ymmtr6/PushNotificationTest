//
//  PushNotificationTestWidgetLiveActivity.swift
//  PushNotificationTestWidget
//
//  Created by Riku Yamamoto on 2024/04/14.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct PushNotificationTestWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PushNotificationTestWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PushNotificationTestWidgetAttributes {
    fileprivate static var preview: PushNotificationTestWidgetAttributes {
        PushNotificationTestWidgetAttributes(name: "World")
    }
}

extension PushNotificationTestWidgetAttributes.ContentState {
    fileprivate static var smiley: PushNotificationTestWidgetAttributes.ContentState {
        PushNotificationTestWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PushNotificationTestWidgetAttributes.ContentState {
         PushNotificationTestWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PushNotificationTestWidgetAttributes.preview) {
   PushNotificationTestWidgetLiveActivity()
} contentStates: {
    PushNotificationTestWidgetAttributes.ContentState.smiley
    PushNotificationTestWidgetAttributes.ContentState.starEyes
}
