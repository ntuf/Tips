import UIKit

var number: Int? = 42
var newNumber: Int = number!

//!は「ここには値が入っているからOptionalを外したぞ！」と明示するということですが、
//この値の保証はプログラマが担保するものと思ってよいでしょう。
//このように!を使用したOptional型のアンラップは、
//アップルのドキュメントでは"ForcedUnwrapping"と書かれています。
//"強制解除"という訳し方になるでしょうか。
//少しお行儀が悪いので、if文でnilチェックを行ってから使用しましょう。

var number: Int? = 42
var newNumber: Int

if number {
    newNumber = number!
}else{
    println("There isn't value")
}
//Optionalな変数をif文に渡すと値が入っていればtrue、
//値がnilの場合はfalseと判定されます。
//きちんとnumber変数がnilでないかをチェックしているので
//比較的安心して使用することができますね。
//このように!=アンラップする際はOptionalがnilでないかを必ず確認しましょう。
//なぜでしょうか？


var number: Int? = nil
var newNumber: Int = number!

//Optional型をアンラップしているため、このコードは静的な型チェックが働きません。しかしランタイムエラーとなってしまいます。これは非常に危険ですよね。
//このような場合、プログラマがnilでないことを保証する必要があります。
//とは言え、よほどスコープの狭い変数以外は完璧に保証することは難しいですよね。
//ですので!を使用する際はif文によるnilチェックを必ず行いましょう。

