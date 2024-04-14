//
//  ContentView.swift
//  PushNotificationTest
//
//  Created by Riku Yamamoto on 2024/04/14.
//

import SwiftUI
import ActivityKit
import PushNotificationTestWidgetExtension

class AppDelegate: NSObject, UIApplicationDelegate {
    // デバイストークンを受け取ったときに呼び出されるメソッド
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // デバイストークンを文字列に変換し、プロパティに設定
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
        
        // 取得したデバイストークンを永続化する
        UserDefaults.standard.set(token, forKey: "deviceToken")
    }
    
    // デバイストークンの取得に失敗したときに呼び出されるメソッド
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
}

struct ContentView: View {
        
    init(){
        // 通知の許可を要求
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
                // 通知の許可が得られたら、デバイストークンを要求
                DispatchQueue.main.async {
                    if !UIApplication.shared.isRegisteredForRemoteNotifications {
                        print("call registerForRemoteNotifications")
                        UIApplication.shared.registerForRemoteNotifications()
                    } else {
                        print("already deviceToken")
                    }
                }
            } else {
                print("Notification permission denied: \(error?.localizedDescription ?? "")")
            }
        }

    }
    
    func getPushToStartToken() {
        if #available(iOS 17.2, *) {
            Task {
                // Push-to-start トークンを取得する
                for await data in Activity<PushNotificationTestWidgetAttributes>.pushToStartTokenUpdates {
                    let token = data.map {String(format: "%02x", $0)}.joined()
                    print("Activity PushToStart Token: \(token)")
                    UserDefaults.standard.setValue(token, forKey: "pushToStartToken")
                }
            }
        }
    }
    
    func startActivity() {
        print("start liveactivity")
        let attributes = PushNotificationTestWidgetAttributes(name: "test")
        let initContentState = PushNotificationTestWidgetAttributes.ContentState(emoji: "🥺")
        do {
            // アプリ上から activityを開始する
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: initContentState, staleDate: nil),
                pushType: .token
            )
            
            Task {
                // トークンは期間内に更新されることがある
                // 複数個発行できる
                for await pushToken in activity.pushTokenUpdates {
                    let pushTokenString = pushToken.reduce("") {
                        $0 + String(format: "%02x", $1)
                    }
                    print("New push token: \(pushTokenString)")
                    // 取得したデバイストークンを永続化する
                    UserDefaults.standard.set(pushTokenString, forKey: "pushToken")
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func endActivity() {
        print("end liveactivity")
        Task {
            for activity in Activity<PushNotificationTestWidgetAttributes>.activities {
                await activity.end(activity.content)
            }
        }
    }
    
    var body: some View {
        var deviceToken = UserDefaults.standard.string(forKey: "deviceToken") ?? "No Token"
        var pushToken = UserDefaults.standard.string(forKey: "pushToken") ?? "No Token"
        var pushToStartToken = UserDefaults.standard.string(forKey: "pushToStartToken") ?? "No Token"
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("PUSH Notification Test")
            Button(action: {
                deviceToken = UserDefaults.standard.string(forKey: "deviceToken") ?? "No Token"
                pushToken = UserDefaults.standard.string(forKey: "pushToken") ?? "No Token"
                pushToStartToken = UserDefaults.standard.string(forKey: "pushToStartToken") ?? "No Token"
            }) {
                Text("UPDATE")
            }
            Button(action: {
                startActivity()
            }) {
                Text("Start LiveActivity")
            }
            Button(action: {
                getPushToStartToken()
            }) {
                Text("Get PushToStartToken")
            }
            Button(action: {
                endActivity()
            }) {
                Text("Finish LiveActivity")
            }
            
            // トークンの内容表示
            Button(action: {
                UIPasteboard.general.string = deviceToken
            }) {
                Text("DeviceToken: " + deviceToken).padding()
            }.disabled(deviceToken == "No Token")
            Button(action: {
                UIPasteboard.general.string = pushToken
            }) {
                HStack{
                    Text("PushToken: ")
                    Text(pushToken)
                }.padding()
            }.disabled(pushToken == "No Token")
            Button(action: {
                UIPasteboard.general.string = pushToStartToken
            }) {
                HStack{
                    Text("pushToStartToken: ")
                    Text(pushToStartToken)
                }.padding()
            }.disabled(pushToStartToken == "No Token")

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
