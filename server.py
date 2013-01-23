from flask import Flask
from flask import render_template, jsonify, request, Response
import json
import os
app = Flask(__name__)

tweets = []

@app.route('/')
def get_home():
	return render_template('tweets.html')

@app.route('/last/<num>')
def get_last(num):
	return render_template('tweets.html')

@app.route('/api/tweets', methods=['GET', 'POST'])
def api_tweets():
	if request.method == 'POST':
		tweet = request.json
		tweet["id"] = len(tweets) + 1
		tweets.append(request.json)
		return jsonify(request.json)
	else:
		limit = request.args.get('limit', 0)
		if limit == 0:
			t = json.dumps(tweets)
		else:
			l = int(limit) - 1
			t = json.dumps(tweets[l:])
		res = Response(response=t, content_type='application/json')
		return res

if __name__ == '__main__':
	#app.debug = True
	#app.run()
	port = int(os.environ.get('PORT', 5000))
	app.run(host='0.0.0.0', port=port)