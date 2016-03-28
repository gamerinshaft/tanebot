# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   ping - Reply with pong

module.exports = (robot) ->
  exec = require('child_process').exec
  robot.respond /directory$/i, (msg) ->
    exec 'ls -l ./', (err, stdout, stderr) ->
      msg.send err
      msg.send stdout
      msg.send stderr
  robot.respond /ishibashi test$/i, (msg) ->
    exec 'sudo python ~/ishibashi/unit_test.py', (err, stdout, stderr) ->
      data = stderr.replace(/\=\=\=\=\=/g, "-----")
      data = data.split("----------------------------------------------------------------------")
      indicator = data.shift().replace(/\r?\n/g,"")
      result = data.pop().replace(/\r?\n/g," ")
      if data.size == 0
        color = "#2e993e"
        pretext = "テストを実行したよ、成功したよ！"
      else
        color = "#c4001a"
        pretext = "テストを実行したよ、失敗だったよ…"
      text = ""
      data.forEach (msg, index) ->
        if index % 2 == 0
          text += "*" + msg.replace(/\r?\n/g,"") + "*\n"
        else
          text += "> " + msg.replace(/\r?\n/g,"") + "\n"

      robot.emit 'slack.attachment',
        message: msg.message
        content:[{
            pretext: pretext
            color: color
            mrkdwn_in: ["text", "pretext", "fields"]
            text: text
            fields: [{
                title: "テスト結果"
                value: "`" + indicator + "`"
                short: 1
            },{
                title: "経過時間"
                value: "`" + result + "`"
                short: 1
            }]
        }]
