// import dependencies
import {Socket} from "phoenix"

class App {

  // constructor / init method
  static init(){
    // create socket
    let socket = new Socket("/socket", {})

    // connect socket
    socket.connect({})

    var $status    = $("#status")
    var $messages  = $("#messages")
    var $input     = $("#message-input")
    var $username  = $("#username")

    socket.onOpen( ev => console.log("OPEN", ev) )
    socket.onError( ev => console.log("ERROR", ev) )
    socket.onClose( e => console.log("CLOSE", e))

    // create channel
    var chan = socket.channel("rooms:lobby", {})

    // join channel
    chan.join()
      .receive("ignore", () => console.log("auth error"))
      .receive("ok", () => console.log("join ok"))

    chan.onError(e => console.log("something went wrong", e))
    chan.onClose(e => console.log("channel closed", e))

    // send message
    $input.off("keypress").on("keypress", e => {
      if (e.keyCode == 13) {
        chan.push("new:msg", {user: $username.val(), body: $input.val()})
        $input.val("")
      }
    })

    // incoming message event
    chan.on("new:msg", msg => {
      $messages.append(this.messageTemplate(msg))
      scrollTo(0, document.body.scrollHeight)
    })

    // incoming message event
    chan.on("ping:msg", msg => {
      console.log(msg)
    })

    // incoming message event
    chan.on("user:entered", msg => {
      let username = msg.user || "anonymous"
      $messages.append(`<br/><i>[${username} entered]</i>`)
    })
  }

  // template
  static messageTemplate(msg){
    let username = msg.user || "anonymous"
    let body     = msg.body
    return(`<div><p>${username} : ${body}</p></div>`)
  }

}

$( () => App.init() )

export default App
