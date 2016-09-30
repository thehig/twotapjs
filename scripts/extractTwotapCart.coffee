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

parseOpts = ->
	new Promise((ccb, ecb)->

		optparse = require('optparse')
		switches = [
			['-i', '--input INPUTFILE', '*Required* Input file to be processed'],
			['-o', '--output OUTPUTFILE', '*Optional* Output file to write to if provided, or write to screen'],
			['-h', '--help', 'Display this help document']
		]

		parser = new (optparse.OptionParser)(switches)
		parser.banner = 'Usage:\tcoffee scripts/extractTwotapCart.coffee [OPTIONS]\n\teg:\tcoffee scripts/extractTwotapCart.coffee -i scripts/fixtures/magentoCart.fixture.json'
		parser.options_title = 'Magento Cart Extraction Options:\n'

		showUsage = (code, ecb) ->
			code = code or 0
			console.log chalk.yellow('\nTwotap Magento Cart Extractor: version') + chalk.green(' **' + version + '**')
			console.log chalk.yellow('\n' + parser.toString())
			if(ecb)
				return ecb(code)
			else 
				process.exit code

		parser.on 'input', (k, v) ->
			config.source = v
		
		parser.on 'output', (k, v) ->
			config.sink = v

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
		console.log(chalk.cyan("\nLoading cart file\n"));
		jf.readFile(path.resolve(process.cwd(), config.source), (err, obj)->
			if(err) 
				return ecb(err)
			ccb(obj)
		)
	).then((magentoCart)->
		processedOpts.magentoCart = magentoCart
	)

parseOpts()
.then(null, (errCode)->
	console.log("Error parsing opts " + errCode);
	process.exit errCode
)
.then(processOpts)
.then((cartObj)->
	if(!processedOpts.magentoCart) 
		throw new Error("No source object provided")

	if(!cartObj.response)
		throw new Error("No response in cart")
	
	return JSON.parse(cartObj.response);
)
.then((purchaseObject)->
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
