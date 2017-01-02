# DynamicConversation = require 'hubot-dynamic-conversation'

# module.exports = (robot)->

#     robot.hear /(h+i+)|(h+e+l+o+)/i, (res) ->
#         res.send "Hello friend! How are you?"

#     robot.hear /^(o+i+)|(e+i+)|(o+l+a+)/i, (res) ->
#         res.send "Olá #{res.message.user.name}! :)\nMuito prazer em te conhecer!\nEu sou apenas uma parte dele, mas adoraria conversar, você gostaria me conhecer melhor?"
#         res.send "Fique a vontade para me perguntar qualquer coisa e tentarei te responder, caso não consiga, entrarei em contato com o meu eu verdadeiro e com certeza te responderei em outro momento."
#         res.send "Para saber o que você pode me perguntar, envie uma mensagem com o seguinte conteudo: 'O que posso perguntar?'"

#     robot.hear /(t+u+d+o+ (b+(o|e)+m+))|(c+e+r+t+(o)|(i+n+h+o+))|(e+i+)|(o+l+a+)\?/i, (res) ->
#         res.send "Tudo sim, obrigado por perguntar!"

#     robot.hear /(onde (voc(ê|e)|(vc)) trabalha\?|(voc(ê|e)|(vc)) trabalha onde\?)/i, (res) ->
#         lat = -8.047437
#         long = -34.8991887
#         msg = "Meu humilde local de trabalho"
#         res.send "Trabalho no CERS, uma empresa de cursos online. Você pode conhecer melhor através do site www.cers.com.br."
#         res.envelope.fb = location_msg lat, long, msg

#     robot.hear /(de)? ?(onde|em que lugar) ((voc(ê|e))|(vc)) ((e|é)|(mora|vive))\?/i, (res) ->
#         res.send "Eu sou do ipsep, elite do Recife, só que n, hahahah."
#         lat = -8.117450
#         long = -34.91602
#         msg = "Minha humilde residencia"
#         res.envelope.fb = location_msg lat, long, msg

#     robot.hear /(como te encontro|como te encontrar|onde est(a|á) vc|onde vc est(a|á))\?/i, (res) ->
#         res.send "Normalmente você pode me encontrar em casa ou no trabalho, para saber onde moro ou trabalho, pergunte: 'Onde vc mora?' ou 'Onde vc trabalha?' respectivamente :)"

#     robot.hear /qual +(a|é|é a|e a)? ?sua hist(o|ó)ria\?/i, (res) ->
#         res.send "Meu nome é João Artur, eu foi criado por um cientista maluco num experimento que visava descobrir o segredo do universo."
#         res.send "Infelizmente somente ele agora possui tal informação.\n Se você deseja ajuda-lo nessa nova descoberta você deve encontra-lo, para isso,\n descubra onde eu moro."

#     robot.hear /o que posso (te)? ?perguntar\?/i, (res) ->
#         res.send "Atualmente sou capaz de te responder as seguintes mensagens: \nOnde vc mora?\nOnde vc trabalha?\nQual é sua historia?\nComo te encontro?\nO que vc gosta de ouvir?"

#     conversation = new DynamicConversation robot

#     robot.hear /o que e o que e\?/i, (msg) ->
#         msg.reply "Welcome to TraderBot. Let's get started..."

#         conversationModel = 
#             abortKeyword: "quit"
#             onAbortMessage: "You have cancelled the transaction"
#             onCompleteMessage: "Thankyou for using TraderBot."
#             conversation: [
#                     question: "Do you want to sell or buy?"
#                     answer: 
#                         type: "choice"
#                         options: [
#                                 match: "sell"
#                                 valid: true
#                                 response: "OK you said *sell*, next step..."
#                                 value: "sell"
#                             ,
#                                 match: "buy"
#                                 valid: false
#                                 response: "Ok, I will forward you to our sales department."
#                         ]
#                     required: true
#                     error: "Sorry, I didn't understand your response. Please say buy or sell to proceed."
#                 ,
#                     question: "Please describe the issue."
#                     answer:
#                         type: "text"
#                     required: true
#                     error: "Sorry your response didn't contain any text, please describe the issue."
#                 ,
#                     question: "Please attach a photo of the issue if you have one."
#                     answer:
#                         type: "attachment"
#                     required: false
#                     error: "Sorry the message didn't contain an attachment, please try again."
#             ]

#         dialog = conversation.start msg, conversationModel, (err, msg, dialog) ->
#             if err?
#                 return console.log "error occured in the dialog #{err}"

#             console.log "Thank you for using TraderBot."
#             dialogData = dialog.fetch()
#             console.log dialogData

#     location_msg = (lat, long, msg)->
#         richMsg:
#                 attachment: 
#                     type: "template",
#                     payload: 
#                         template_type: "generic"
#                         elements:
#                             element:
#                                 "title": msg
#                                 "image_url": "https:\/\/maps.googleapis.com\/maps\/api\/staticmap?size=764x400&center="+lat+","+long+"&zoom=25&markers="+lat+","+long
#                                 "item_url": "http:\/\/maps.apple.com\/maps?q="+lat+","+long+"&z=16"