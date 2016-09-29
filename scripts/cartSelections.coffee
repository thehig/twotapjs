version = require('../package.json').version;

_ = require('lodash')
path = require('path')
fs = require('fs')
jf = require('jsonfile')

chalk = require('chalk')
chalk.enabled = true

config = {
};

# if(!process.stdout.isTTY)
# 	console.log("Please run this application from a TTY compatible shell")
# 	process.exit -1

dp = require('../src/twotapJSONDataProvider')
service = new dp.JSONDataProvider()

parseOpts = ->
	new Promise((ccb, ecb)->

		optparse = require('optparse')
		switches = [
			['-i', '--input INPUTFILE', '*Required* Input file to be processed'],
			['-u', '--user USERDETAILS', '*Required* User details to be attached'],
			['-c', '--callback CALLBACKCONFIG', '*Required* Callback Config to be attached'],
			['-h', '--help', 'Display this help document']
		]

		parser = new (optparse.OptionParser)(switches)
		parser.banner = 'Usage:\tcoffee scripts/cartSelections.coffee [OPTIONS]\n\teg:\ttwotapjs>coffee scripts/cartSelections.coffee -i cart.fixture.json -u userDetails.fixture.json -c callbackConfig.fixture.json'
		parser.options_title = 'Twotap Cart Selections Options:\n'

		showUsage = (code, ecb) ->
			code = code or 0
			console.log chalk.yellow('\nTwotap Cart Selections version') + chalk.green(' **' + version + '**')
			console.log chalk.yellow('\n' + parser.toString())
			if(ecb)
				return ecb(code)
			else 
				process.exit code

		parser.on 'input', (k, v) ->
			config.source = v

		parser.on 'user', (k, v) ->
			config.userDetails = v

		parser.on 'callback', (k, v) ->
			config.callbackConfig = v
			
		parser.on 'help', -> showUsage(0, ecb)

		parser.on (opt) ->
			# Catch any unhandled switches and exit
			console.log '\n[-] No handler defined for ' + opt + '\n'
			showUsage(-1, ecb)

		# If there are no arguments, showUsage
		if process.argv.length <= 2
			console.log("Insufficient arguments")
			showUsage(-1, ecb)
		try
			parser.parse process.argv
		catch e
			console.log '\n[-] Error parsing options: ' + e
			showUsage(-1, ecb)

		ccb()
	)

processedOpts = {}
processOpts = ->
	new Promise((ccb, ecb)->
		console.log("Loading cart file");
		jf.readFile(path.resolve(__dirname, config.source), (err, obj)->
			if(err) 
				return ecb(err)
			ccb(obj)
		)
	).then((sourceObj)->
		new Promise((ccb, ecb)->
			processedOpts.sourceObj = sourceObj
			console.log("Loading user details file");
			jf.readFile(path.resolve(__dirname, config.userDetails), (err, obj)->
				if(err) 
					return ecb(err)
				ccb(obj)
			)
		)
	).then((userDetails)->
		new Promise((ccb, ecb)->
			processedOpts.userDetails = userDetails
			console.log("Loading callback config file");

			jf.readFile(path.resolve(__dirname, config.callbackConfig), (err, obj)->
				if(err) 
					return ecb(err)
				ccb(obj)
			)
		)
	).then((callbackConfig)->
		processedOpts.callbackConfig = callbackConfig
	)

afterOpts = ()->
	if(!processedOpts.sourceObj)
		throw new Error("No source object provided")

	service.GetCart(processedOpts.sourceObj)
	# console.log(JSON.stringify(processedOpts, null, 4))


parseOpts()
.then(null, (errCode)->
	console.log("Error parsing opts " + errCode);
	process.exit errCode
)
.then(processOpts)
.then(afterOpts)
.then((cartObj)->
	console.log("\n\nGenerating Selections")

	_.forEach(cartObj.sites, (site)->
		console.log("Site: " + site.name)

		_.forEach(site.add_to_cart, (product)->
			console.log("\tProduct: " + product.title)

			_.forEach(product.required_fields, (required_field)->
				fieldId = 0
				console.log("\t\tField: " + required_field.name + "[0] -- (" + required_field.observableValues[fieldId].text + ")")
				service.clickOption(required_field.observableValues[fieldId])
			)
		)
	)

	console.log(chalk.green("\n\n\n====GENERATING PURCHASE OBJECT====\n\n\n"))
	return service.Purchase(cartObj, processedOpts.userDetails, processedOpts.callbackConfig)
)
.then((purchaseObject) ->
	console.log(JSON.stringify(purchaseObject, null, 4))
)
.then(null, (err)->
	console.log("Exiting with error " + err.message);
	process.exit -1
)
