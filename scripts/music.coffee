module.exports = (robot) ->
	
	YOUTUBE_API_KEY = 'AIzaSyBKHPMswKSmrxqrP3B1AOzQAf2GsV_pZzQ'

	musics =
		'hiphop': [
				"6vYnas6q3Sg",
				"cTGQrA5HHIU",
				"Tz6OUIjtM6E",
				"qMwcsIY1GYE",
				"4NJlUribp3c",
				"K_9tX4eHztY",
				"MXGORPXI6QQ",
				"TzXz-xLB1-0",
				"TUj0otkJEBo",
				"YmbTAvYU3As",
				"S-sJp1FfG7Q"
			] 

	robot.hear /(que tipo de musica vc (gosta|curte)|o que vc gosta de ouvir|que tipo de musica vc gosta)\?/i, (res) ->
	        res.send "Eu gosto de todos os tipos de musica, menos sertaneijo, e não me pergunte o porque, apenas ainda não evolui o suficiente para adiquirir esse gosto."
	        res.send "Porém, curto mesmo um psy, hiphop, rap, rock, metal...\n acho que é isso. Se vc quer escutar uma musica massa, faça um pedido mandando a mensagem: 'Toca o som DJ' "
	

	robot.hear /toca o som dj/, (res)->
		id = res.random musics.hiphop
		# robot.http("https://www.googleapis.com/youtube/v3/videos?part=snippet&id=#{id}&fields=items/snippet/title,items/snippet/description&key=#{YOUTUBE_API_KEY}")
		#     .header('Accept', 'application/json')
		#     .get() (err, res2, body) ->
		#       # error checking code here

		#       data = JSON.parse body
		#       res.send "#{data} taking midnight train going #{data}"
		robot.http("https://www.googleapis.com/youtube/v3/videos?part=snippet&id=#{id}&fields=items/snippet/title,items/snippet/description&key=#{YOUTUBE_API_KEY}")
			.header('Accept', 'application/json')
			.get() (err, res2, body) ->
				data = JSON.parse body
				console.log(data.items[0].snippet.title)
				console.log(youtube_video_msg(id, data.items[0].snippet.title))
				res.envelope.fb = youtube_video_msg(id, data.items[0].snippet.title)
				res.send()

	youtube_video_msg = (id, msg = "Musica massa!")->
		richMsg:
			attachment: 
				type: "template"
				payload: 
					template_type: "generic"
					elements:
						element:
							"title": msg
							"image_url": "https://img.youtube.com/vi/#{id}/default.jpg"
							"item_url": "https://www.youtube.com/watch?v=#{id}"