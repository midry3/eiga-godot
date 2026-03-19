# 基本的な書き方

```
@EigaCharacterのノード名
スクリプト

...

-> 遷移先のシーン
```

# `@`構文
`@EigaCharacterのノード名`で新規テキストボックスで表示

# `->`構文
`-> シーン`で、読み込むシーンを指定します
`UID`での指定をおすすめします

なお、実際には`scene_load`シグナルが発生しており、このシグナルと接続して処理することになります

# スクリプトにおける特殊関数
[関数名(引数1, 引数2, ...)]で呼び出す
[&関数名(引数1, 引数2, ...)]とすると非同期で、つまり処理を待たずにテキストを進めます

## 関数紹介
- move("Animation Name", Velocity.x, Velocity.y, Time)
アニメーション名`Animation Name`を再生しつつ、Velocityの速度でTime秒間動く

- call("Function Name", Arg1, Arg2, ...)
関数名`Function Name`を引数を渡しつつ呼ぶ
特定のキャラクターの関数を呼びたいときは`EigaCharacterのノード名:関数名`で指定

- pause()
クリック待ち

- wait(Time)
Time秒待つ

- term()
現在処理中の非同期処理を全てキルし、最終値にする

# 例
```
@CharacterA
テスト

@CharacterB
[move("right", 2, 100)]
例えば[wait(0.5)].[wait(.5)].[wait(.5)].

@-
[&move("right", 3, 200)]
ajsiojsoisjoisjslilslinsjlknmk
[pause()]jisjosjoisjosk
[term()]だ！


@
[zoom(x, y, scale)]

-> uid://nbcciyufjgou # 飛ぶシーン
```