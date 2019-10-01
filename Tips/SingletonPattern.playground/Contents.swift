import UIKit

class Manager1 {
    static let sharedManager = Manager1()
    private init() {
    }
}

//クロージャを使用したシングルトン
class Manager2 {
    static var sharedManager: Manager2 = {
        return Manager2()
    }()
    private init() {
    }
}

var managerA = Manager1.sharedManager
var managerB = Manager1.sharedManager
managerA === managerB // true

var managerC = Manager2.sharedManager
var managerD = Manager2.sharedManager
managerC === managerD // true

print("--------------------------------------")

//iOSアプリでは起動時にまず application(_:didFinishLaunchingWithOptions:)
//というメソッドが呼び出されますが、この引数の application は
//UIApplication.shared というシングルトンプロパティで取得できるものと同一。

//func application(_ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions:
//        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//  // 起動時の処理
//}

print("--------------------------------------")

class Singleton: NSObject {
     
    class var sharedInstance: Singleton {
        struct Static {
            static let instance : Singleton = Singleton()
        }
        return Static.instance
    }
    
    // ここにプロパティを追加する
    var num : Int!
    var str : String!
    
}

Singleton.sharedInstance.num = 1
Singleton.sharedInstance.str = "あいうえお"


print("--------------------------------------")
//シングルトンを使って
//コンフィギュレーションクラスでRelease/Debug環境を分ける


struct Configuration {
    static let shared = Configuration()

    private let config: [AnyHashable: Any] = {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: path) as! [AnyHashable: Any]
        return plist["AppConfig"] as! [AnyHashable: Any]
    }()

    let URL: String
    //...

    private init() {
        URL = config["API URL(Info.plistのKey)"] as! String
        //...
    }
}
// ■Info.plist
//     Key           Type         Value
//     AppConfig     Dictionary
//       - API URL   String       $(API_URL)
//
// ■[BuildSettings][UserDefined]
//    API_URL - Debug
//            - Release
//

print("--------------------------------------")


