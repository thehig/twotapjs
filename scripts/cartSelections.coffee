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
			['-o', '--output OUTPUTFILE', '*Optional* Output file to write to if provided, or write to screen'],
			['-h', '--help', 'Display this help document']
		]

		parser = new (optparse.OptionParser)(switches)
		parser.banner = 'Usage:\tcoffee scripts/cartSelections.coffee [OPTIONS]\n\teg:\tcoffee scripts/cartSelections.coffee -i scripts/fixtures/cart.fixture.json -u scripts/fixtures/userDetails.fixture.json -c scripts/fixtures/callbackConfig.fixture.json'
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

		parser.on 'output', (k, v) ->
			config.sink = v			

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
		console.log(chalk.cyan("Loading cart file"));
		jf.readFile(path.resolve(process.cwd(), config.source), (err, obj)->
			if(err) 
				return ecb(err)
			ccb(obj)
		)
	).then((sourceObj)->
		new Promise((ccb, ecb)->
			processedOpts.sourceObj = sourceObj
			console.log(chalk.cyan("Loading user details file"));
			jf.readFile(path.resolve(process.cwd(), config.userDetails), (err, obj)->
				if(err) 
					return ecb(err)
				ccb(obj)
			)
		)
	).then((userDetails)->
		new Promise((ccb, ecb)->
			processedOpts.userDetails = userDetails
			console.log(chalk.cyan("Loading callback config file"));

			jf.readFile(path.resolve(process.cwd(), config.callbackConfig), (err, obj)->
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
	console.log(chalk.cyan("\n\nGenerating Selections\n"))

	_.forEach(cartObj.sites, (site)->
		console.log("Site: " + chalk.magenta(site.name))

		_.forEach(site.add_to_cart, (product)->
			console.log("\tProduct: " + chalk.bgBlue(product.title))

			_.forEach(product.required_fields, (required_field)->
				fieldId = 0
				console.log("\t\tField: " + chalk.yellow(required_field.name) + "[0] -- (" + chalk.green(required_field.observableValues[fieldId].text) + ")")
				service.clickOption(required_field.observableValues[fieldId])
			)
		)
	)

	console.log(chalk.cyan("\n\nGENERATING PURCHASE OBJECT\n"))
	return service.Purchase(cartObj, processedOpts.userDetails, processedOpts.callbackConfig)
)
.then((purchaseObject) ->
	new Promise((ccb, ecb)->
		if(!config.sink) 
			console.log(JSON.stringify(purchaseObject, null, 4))
			return ccb()

		outputPath = path.resolve(process.cwd(), config.sink)

		jf.writeFile(outputPath, purchaseObject, {"flag":"wx"}, (err)->
			if(err) 
				return ecb(err)
			console.log("\nPurchase object written to " + chalk.yellow(outputPath))
			ccb()
		)
	)
)
.then(()->
	console.log(chalk.green("\nDone"))
)
.then(null, (err)->
	console.log(chalk.red("\nExiting with error \n\t") + err.message);
	process.exit -1
)
