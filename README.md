# SCNetworkAgent

[![CI Status](https://img.shields.io/travis/debugly/SCNetworkAgent.svg?style=flat)](https://travis-ci.org/debugly/SCNetworkAgent)
[![Version](https://img.shields.io/cocoapods/v/SCNetworkAgent.svg?style=flat)](https://cocoapods.org/pods/SCNetworkAgent)
[![License](https://img.shields.io/cocoapods/l/SCNetworkAgent.svg?style=flat)](https://cocoapods.org/pods/SCNetworkAgent)
[![Platform](https://img.shields.io/cocoapods/p/SCNetworkAgent.svg?style=flat)](https://cocoapods.org/pods/SCNetworkAgent)



SCNetworkAgent module is a cocoa network abstract layer, business module needn't care the owner network implementation.

The owner must implement SCNetworkAgent's methods by registration before business module send request!

```
├── Agent    网络请求发起类；跟网络实现耦合的类
├── BaseApi  提供基础网络请求
├── DownloadApi 文件下载专用类
├── PostApi     支持带 body 体的请求
├── ResponseParser 响应解析器，检查响应，解析成 JSON，Model等
└── UploadApi   文件上传专用类
```

## Installation

SCNetworkAgent is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SCNetworkAgent'
```

## Author

MattReach, qianglongxu@gmail.com

## License

SCNetworkAgent is available under the MIT license. See the LICENSE file for more info.
