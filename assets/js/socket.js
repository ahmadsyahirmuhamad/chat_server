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
    var chan = socket.channel("rooms:one", {})

    // join channel
    chan.join()
      .receive("ignore", () => console.log("auth error"))
      .receive("ok", () => console.log("join ok"))

    chan.onError(e => console.log("something went wrong", e))
    chan.onClose(e => console.log("channel closed", e))

    // send message
    $input.off("keypress").on("keypress", e => {
      if (e.keyCode == 13) {
        chan.push("new:msg", {id: "one",user: $username.val(), body: $input.val()})
        $input.val("")
      }
    })

    // incoming message event
    chan.on("new:msg", msg => {
      console.log("aaaaa", msg)
      $messages.append(this.messageTemplate(msg))
      scrollTo(0, document.body.scrollHeight)
    })

    // incoming message event
    chan.on("ping:msg", msg => {
      // console.log(msg)
    })

    // incoming message event
    chan.on("user:entered", msg => {
      let username = msg.user || "anonymous"
      $messages.append(`<br/><i>[${username} entered]</i>`)
    })

    //
    // create channel
    var chanFloat = socket.channel("floating:msg", {})

    // join channel
    chanFloat.join()
      .receive("ignore", () => console.log("auth error"))
      .receive("ok", () => console.log("join ok"))

    chanFloat.onError(e => console.log("something went wrong", e))
    chanFloat.onClose(e => console.log("channel closed", e))

    // incoming message event
    chanFloat.on("new:msg", msg => {
      console.log('floating', msg)
      $messages.append(this.messageTemplate(msg))
      scrollTo(0, document.body.scrollHeight)
    })

    // incoming message event
    chanFloat.on("ping:msg", msg => {
      // console.log("floating", msg)
    })

  } //end init

  // template
  static messageTemplate(msg){
    let username = msg.user || "anonymous"
    let body     = msg.body
    return(`<div><p>${username} : ${body}</p></div>`)
  }



}

$( () => App.init() )

export default App
