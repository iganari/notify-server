# bin

## send-notify.sh

+ slackに送るメッセージを作成するshell
+ 最後に `notify-me.sh` を実行する

## notify-me.sh

+ パイプで渡された標準出力をslackの特定のチャンネルに送信する
+ フォーマットは固定だが、何行でも送信出来る
