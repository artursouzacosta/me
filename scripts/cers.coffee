DynamicConversation = require 'hubot-dynamic-conversation'
removeDiacritics = require('diacritics').remove;

module.exports = (robot)->

	String::strip = -> if String::trim? then @trim() else @replace /^\s+|\s+$/g, ""
	String::lstrip = -> @replace /^\s+/g, ""
	String::rstrip = -> @replace /\s+$/g, ""

	access_token = "access_token=812a4de1444927a45783ae83381cfe24"
	
	api_base_url = "http://localhost:8080/"
	
	category_groups_api_path = "apiCersWs/api/v1/groups?#{access_token}"

	products_grups_api_path = "apiCersWs/api/v1/products?#{access_token}"

	cg_url = api_base_url + category_groups_api_path

	prods_url = api_base_url + products_grups_api_path

	robot.brain.data.groups = null

	robot.hear /^(o+i+)|(e+i+)|(o+l+a+)/i, (res) ->
		res.send "Olá #{res.message.user.name}!\nSeja bem vindo ao CERS Cursos online.\nEstou aqui para te ajudar a encontrar o que você procura, dentro do universo CERS.\n\
		Para saber em que posso te ajudar envie a mensagem: '#ajuda'"

	robot.hear /^ *#ajuda *$/i, (res) ->
		res.send "#{res.message.user.name}, atualmente posso te ajudar em:\n#cursos\n#promocoes\n#noticias\n#compras"

	robot.hear /^ *#cursos *$/i, (res) ->
		robot.brain.data.load_groups (groups)->
				list = "Atualmente temos cursos para as seguintes áreas:\n"
				list += "#{cat.nome}\n" for cat in groups
				res.send list
				res.send "Para listar cursos de uma área especifica, envie: '#cursos NOME_AREA'"


	robot.hear /^ *#cursos (.*)/i, (res) ->

		group = res.match[1].strip()

		robot.brain.data.load_groups (groups)->

			g_id = g.id for g in groups when removeDiacritics(g.nome.toLowerCase()) is (group.toLowerCase())

			if g_id 
				robot.http(prods_url + "&group_id=#{g_id}")
				.header('Accept', 'application/json')
				.get() (err, res2, body) ->
					data = JSON.parse body
					list = "Ultimos cursos lançados na categoria #{group}:\n"
					list += "#{prod.name}\n" for prod in data
					if data.length > 0
						res.envelope.fb = course_buttom_msg(data)
						res.send()
					else
						res.send "Desculpe, não consegui encontrar nenhum curso nessa categoria"
			else
				res.send "Desculpe, não consegui encontrar a área informada, verifique se foi digitada de forma correta e tente novamente"


	robot.brain.data.load_groups = (callback)->
		if robot.brain.data.groups == null
			robot.http(cg_url)
				.header('Accept', 'application/json')
				.get() (err, res2, body)->
					data = JSON.parse body
					robot.brain.data.groups = data
					callback data
		else
			callback robot.brain.data.groups

	course_buttom_msg = (products)->
		result = richMsg:
			attachment:
				type: "template"
				payload:
					template_type: "list"
					top_element_style: "large"
					elements: []
					buttons: [
							"type":"web_url",
							"url":"https://www.cers.com.br/cursos/#grupo/#{products[0].groupSlug}",
							"webview_height_ratio": "compact"
							"title": "Mais Cursos",
					]
		for x in [0..products.length]
			prod = products[x]
			if x <= 3
				result.richMsg.attachment.payload.elements.push
					title: prod.name
					image_url: prod.image
					subtitle: "Mais detalhes"
					default_action:
						type: "web_url"
						url: "https://www.cers.com.br/cursos/#{prod.groupSlug}/#{prod.categorySlug}/#{prod.slug}"
						messenger_extensions: true
						webview_height_ratio: "tall"
						fallback_url: "https://www.cers.com.br/cursos/#{prod.groupSlug}/#{prod.categorySlug}/#{prod.slug}"
					buttons: [
						title: "Adicionar ao carrinho",
						type: "web_url",
						url: "https://www.cers.com.br/carrinho/adiciona/#{prod.slug}"
						messenger_extensions: true,
						webview_height_ratio: "tall",
						fallback_url: "https://www.cers.com.br/carrinho/adiciona/#{prod.slug}"
					]
		return result



