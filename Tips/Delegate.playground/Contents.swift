import UIKit

protocol ButtonDelegate { //プロトコルで宣言する
    func audio()
    func background()
}

class Button {
    var delegate: ButtonDelegate? = nil //デリゲートを保持する変数
    func click() {
        if let dg = self.delegate {
            dg.audio()
            dg.background()
        }
    }
}

extension Button: ButtonDelegate {
    func audio() {
        print("sound")
    }
    func background() {
        print("show background")
    }
}

let button = Button()
button.delegate = button
button.click()

print("--------------------------------------")
//必要最小限の自作Delegateを作って、その構造を見てみましょう
//クラスSampleがDelegateの移譲元、クラスFooが移譲先です。

//わざわざDelegateという名前がついているのだから、さぞ複雑なメカニズムと思われるでしょうが、
//実態は、ただほかのインスタンスを参照して、そのメソッドを呼んでいるだけです。

//Delegateの意味は、移譲元のクラスの具体的な実装がわからなくても、
//プロトコルの宣言を調べることで、どういうメソッドが移譲元から送られるのかがわかることです。
//サブクラスの作成者がスーパークラスはどのような仕様なのか、
//Overrideした時にどのような挙動をするのかをしっかり把握している事も必須ですし、
//スーパークラスの作成者も、自分の作成したクラスのメソッドなどがOverrideされることを考慮して設計しなくてはなりません。
//このような懸念を考慮して、Cocoa Frameworkでは頻繁にdelegateパターンを使い、
//Overrideすること無くユーザに特定の処理を委任しています。

class Sample {

    var value: Int

    weak var delegate: SampleDelegate?

    init() {
        value = 0
    }

    func actionAnyThing() {
        // Send Delegate
        if let delegate = delegate {
            delegate.sampleDidAnything(object: self)
        }
    }
}

protocol SampleDelegate: class {      //プロトコルで宣言
    func sampleDidAnything(object: Sample)
}

extension SampleDelegate {
    func sampleDidAnyThing(object: Sample) {
        print("Delegate not declared")
    }
}

class Foo: SampleDelegate {      //移譲先

    // Delegate Method
    func sampleDidAnything(object: Sample) {
        print("Foo said \"Sample value = \(object.value)\"")
    }
}

let sample = Sample()
sample.value = 100
let foo = Foo()
sample.delegate = foo
sample.actionAnyThing()

// 出力：Foo said "Sample value = 100"





