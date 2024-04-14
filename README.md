# PushNotificationTest

iOSでRemotePushするためのサンプル


- RemotePush用のdeviceTokenを発行する
- LiveActivityを開始し、pushTokenを発行する(iOS16.2)
- PushToStart Tokenを発行する(iOS 17.2)



## Payload集

### 通常push
```
{
  "aps": {
    "alert": {
      "title": "通知テスト",
      "subtitle": "サブタイトル",
      "body": "ボディ"
    },
    "sound": "default"
  }
}

```

### Push-To-Start Tokenを利用してLiveActivityを開始する

```
{
  "aps": {
    "event": "start",
    "content-state": {
      "emoji": "😎"
    },
    "attributes-type": "PushNotificationTestWidgetAttributes",
    "attributes": {
      "name": "start by push"
    },
    "alert": {
      "title": "title",
      "body": "body"
    },
    "timestamp": 1713108443
  }
}
```

### PushToken を利用してLiveActivityを更新する
```
{
  "aps": {
    "event": "update",
    "content-state": {
      "emoji": "😇"
    },
    "alert": {
      "title": "title",
      "body": "body"
    },
    "timestamp": 1713107114
  }
}
```

### PushToken を利用してLiveActivityを終了する
```
{
  "aps": {
    "event": "end",
    "content-state": {
      "emoji": "😇"
    },
    "alert": {
      "title": "title",
      "body": "body"
    },
    "timestamp": 1713107215
  }
}
```

※apple developerのCloudKit Console　> Push Notifications で　APNsに対してペイロードを投げることができる

