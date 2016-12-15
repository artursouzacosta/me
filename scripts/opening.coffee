DynamicConversation = require 'hubot-dynamic-conversation'

module.exports = (robot)->

    robot.hear /(o+i+)|(e+i+)|(o+l+a+)/i, (res) ->
        res.send "Oláaaa! :)"
        res.send "Muito prazer em te conhecer!"
        res.send "Eu sou apenas uma parte dele, mas adoraria conversar, você gostaria me conhecer melhor?"
        res.send "Fique a vontade para me perguntar qualquer coisa e tentarei te responder, caso não consiga, entrarei em contato com o meu eu verdadeiro e concerteza te responderei em outro momento."
        res.send "Como vai você?"
        res.send "Para saber o que você pode me perguntar, envie uma mensagem com o seguinte conteudo: 'O que posso perguntar?'"

    robot.hear /(t+u+d+o+ (b+(o|e)+m+))|(c+e+r+t+(o)|(i+n+h+o+))|(e+i+)|(o+l+a+)\?/i, (res) ->
        res.send "Tudo sim, obrigado por perguntar!"

    robot.hear /onde (voc(ê|e)|(vc)) trabalha\?/i, (res) ->
        res.send "Trabalho no CERS, uma empresa de cursos online. Você pode conhecer melhor através do site www.cers.com.br."

    robot.hear /(de)? ?(onde|em que lugar) ((voc(ê|e))|(vc)) ((e|é)|(mora|vive))\?/i, (res) ->
        res.send "Eu sou do ipsep, um bairro localizado em Recife/PE."

    robot.hear /qual +(a|é|é a)? sua hist(o|ó)ria\?/i, (res) ->
        res.send "Meu nome é João Artur, eu foi criado por um cientista maluco num experimento que visava descobrir o segredo do universo. Infelizmente somente ele agora possui tal informação. E não foi possível repassar o conhecimento."

    robot.hear /o que posso perguntar\?/i, (res) ->
        res.send "Atualmente sou capaz de te responder as seguintes perguntas: "
        res.send "Onde vc mora?"
        res.send "Onde vc trabalha?"
        res.send "Qual é sua historia?"

    conversation = new DynamicConversation robot

    robot.hear /o que e o que e\?/i, (msg) ->
        msg.reply "Welcome to TraderBot. Let's get started..."

        conversationModel = 
            abortKeyword: "quit"
            onAbortMessage: "You have cancelled the transaction"
            onCompleteMessage: "Thankyou for using TraderBot."
            conversation: [
                    question: "Do you want to sell or buy?"
                    answer: 
                        type: "choice"
                        options: [
                                match: "sell"
                                valid: true
                                response: "OK you said *sell*, next step..."
                                value: "sell"
                            ,
                                match: "buy"
                                valid: false
                                response: "Ok, I will forward you to our sales department."
                        ]
                    required: true
                    error: "Sorry, I didn't understand your response. Please say buy or sell to proceed."
                ,
                    question: "Please describe the issue."
                    answer:
                        type: "text"
                    required: true
                    error: "Sorry your response didn't contain any text, please describe the issue."
                ,
                    question: "Please attach a photo of the issue if you have one."
                    answer:
                        type: "attachment"
                    required: false
                    error: "Sorry the message didn't contain an attachment, please try again."
            ]

        dialog = conversation.start msg, conversationModel, (err, msg, dialog) ->
            if err?
                return console.log "error occured in the dialog #{err}"

            console.log "Thank you for using TraderBot."
            dialogData = dialog.fetch()
            console.log dialogData