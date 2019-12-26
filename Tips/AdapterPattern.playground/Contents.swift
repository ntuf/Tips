import UIKit

//Adapterパターンとは複数のクラスに共通インターフェイスを持たせるパターン
//既存のクラスに手を加えずに実装を追加できる
//というより、既存のクラスに触らずに機能追加できれば、Adapterと言っていい？


//■継承を利用した場合

//ex.このクラスを変更したくない
//  理由：バグの少ない実績がある、そのまま再利用したい
class Target {
    func method1() {
        print(1)
    }
}

//ex.新規でmethod2を作る必要があったので作った。
//   仕様：method1を呼ぶ
//   Targetを継承し、実装。
//   MyProtocolを作成し、継承
class Adapter: Target, MyProtocol {
    func method2() {
        super.method1()
    }
}
protocol MyProtocol {
    func method2()
}


let a = Adapter()
a.method2()

print("--------------------------------------")
//■委譲を利用した場合
//　　（Targetをインスタンス変数として持つ）
//
// 参考) クラスの継承（is-a関係）
// 参考) 委譲（has-a関係）


class Target2 {
    func method1() {
        print(1)
    }
}

//AdapterがTargetをインスタンス変数として持つ
class Adapter2: MyProtocol {
    let target = Target2()
    
    func method2() {
        target.method1()
    }
}

protocol MyProtocol2 {
    func method2()
}


let a2 = Adapter2()
a2.method2()

//※メンバ変数には、クラス変数とインスタンス変数の２種類がある
//     クラス変数：　「static」つきで宣言
//     インスタンス変数：　「static」なしで宣言

print("--------------------------------------")
//■よりswiftyな書き方
//これがスマートな書き方か

class Target3 {
    func method1() {
        print(1)
    }
}

//extensionを使用
extension Target3: MyProtocol {
    func method2() {
        method1()
    }
}

protocol MyProtocol3 {
    func method2()
}

let t = Target3()
t.method2()


//swiftでのAdapterパターンはextensionで実現できると
//とりあえず考えておくことにする
