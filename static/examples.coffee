# Création de la classe d'un Tweet
Tweet = Backbone.Model.extend
	urlRoot: "/api/tweets"
	validate: (attributes)->
		if attributes.author == "" then return "Invalid author"
		if attributes.text == "" or attributes.text.length > 140 then return "Invalid tweet"

# Création d'une collection de tweets
Tweets = Backbone.Collection.extend
	model: Tweet
	url: "/api/tweets"

# Instanciation de la collection
someTweets = new Tweets()

# Affichage des tweets lorsqu'ils sont ajoutés à ma collection
someTweets.on("add",(tweet)->
	view = new TweetView(
		model: tweet
	)
	$("#tweet-list").prepend(view.render().el)
)


# Création d'une vue de tweet
TweetView = Backbone.View.extend
	tagName: "li"
	className: "tweet"
	render: ()->
		tpl = _.template("""<h2><%-author%></h2>
		<p><%-text%></p>""")
		@$el.append(tpl(@model.toJSON()))
		return @

# On écoute le clic sur le bouton de création de tweet
$(()->
	$("#send-tweet").click(()->
		tweet = new Tweet()
		if tweet.save(
			author: $("#author").val()
			text: $("#new-tweet").val()
		)
			someTweets.add(tweet)
			$("#new-tweet").val("").focus()
	)
)

# On crée la classe de routeur
TweetApp = Backbone.Router.extend
	routes:
		"last/:num":	"showLast"
		"*path":		"home"

	showLast: (num)->
		# Récupération des Tweets sur le serveur
		someTweets.fetch(
			update: true
			data:
				limit: num
		)

	home: ()->
		someTweets.fetch(
			update: true
		)
		setInterval(()->
			someTweets.fetch(
				update: true
			)
		,1000)

# Instanciation du routeur
app = new TweetApp()
# Démarrage de l'app
Backbone.history.start({pushState: true})