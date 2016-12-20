module.exports = (robot) ->

	robot.brain.data['GUARABURGER'] = {}
	robot.brain.data['GUARABURGER'].open = false
	robot.brain.data['GUARABURGER'].people = {}
	# robot.brain.data{.}GUARABURGER.opener = ''

	robot.hear /lista guaraburger/i, (res) ->
		g_data = robot.brain.data['GUARABURGER']
		if robot.brain.data.GUARABURGER.open == false
			res.send "A lista do guaraburger ainda não foi aberta, para abrir, envie: 'iniciar guara'"
		else
			res.send "A lista do guaraburger já foi iniciada por #{g_data.opener}, para participar da lista envie 'vou querer guaraburger'"

	robot.hear /iniciar guara/i, (res) ->
		g_data = robot.brain.data['GUARABURGER']
		if g_data.open == false
			g_data.opener = res.message.user.name
			g_data.people[res.message.user.name.toLowerCase()] = []
			g_data.open = true
			res.send "Blz #{g_data.opener}, vc iniciou a lista, para adicionar itens envie: 'vou querer 1 x-frango, 1 misto, 2 sucos de laranja ...'"
		else
			res.send "Lista ja foi iniciada por #{g_data.opener}"

	robot.hear /vou querer guaraburger/i, (res) ->
		g_data = robot.brain.data['GUARABURGER']
		if res.message.user.name.toLowerCase() in g_data.people
			res.send "Você ja está incluso na lista, para adicionar itens envie: 'vou querer 1 x-frango, 1 misto, 2 sucos de laranja ...'"
		else
			g_data.people[res.message.user.name.toLowerCase()] = []
			res.send "Você ja foi adicionado com sucesso, para adicionar itens envie: 'vou querer 1 x-frango, 1 misto, 2 sucos de laranja ...'"
		