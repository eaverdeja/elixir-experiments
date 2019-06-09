// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import {socket, Presence, get_user} from "./socket"

if(get_user()) {
    let presences = {}
    
    let formatedTimestamp = ts => new Date(ts).toLocaleString()
    
    let listBy = (user, {metas}) => ({
        user,
        onlineAt: formatedTimestamp(metas[0]['online_at'])
    })
    
    let onlineUsers = document.getElementById('onlineUsers')
    let render = presences => {
        const userList = Presence.list(presences, listBy)
            .map(({user, onlineAt}) => `
                <li>
                    ${user}
                    <br/>
                    <small>online since ${onlineAt}</small>
                </li>
            `)
            .join('')
        onlineUsers.innerHTML = userList
    }
    
    let room = socket.channel("room:lobby", {})
    room.join()
        .receive("ok", resp => { console.log("Joined successfully", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) })
    
    room.on("presence_state", state => {
            presences = Presence.syncState(presences, state)
            render(presences)
        })
    
    room.on("presence_diff", diff => {
            presences = Presence.syncDiff(presences, diff)
            render(presences)
        })
    
    const messageInput = document.getElementById('newMessage')
    messageInput.addEventListener("keypress", e => {
        if(e.keyCode === 13 && messageInput.value !== '') {
            room.push("message:new", messageInput.value)
            messageInput.value = ''
        }
    })
    
    const messageList = document.getElementById('messageList')
    const renderMessage = ({user, timestamp, body}) => {
        const is_current_user = user === get_user()
        let messageElement = document.createElement('div')
        messageElement.className = 'pt-2'
        messageElement.innerHTML = `
            <div class="card col-8 ${is_current_user ? '' : 'offset-4 text-white bg-dark'}" aria-live="assertive" aria-atomic="true">
                <div class="card-body">
                    <div class="card-title">
                        <strong class="mr-auto">${user}</strong>
                        <small class="${is_current_user ? 'text-muted' : 'text-white'}">${formatedTimestamp(timestamp)}</small>
                    </div>
                    ${body}
                </div>
            </div>

        `
    
        messageList.appendChild(messageElement)
        messageList.scrollTop = messageList.scrollHeight
    }
    
    room.on("message:new", renderMessage)
}
