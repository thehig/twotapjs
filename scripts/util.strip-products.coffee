l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))
fs = require 'fs'

l "[+] Strip Products"

# Get the filename
if process.argv.length != 4
	l "[-] Insufficient parameters."
	l "[-]\t Usage: coffee script.js input output"
	l "[-]\t input is expected to be in the form module.exports = {}"
	l "[-]\t output will contain the valid products only"
	process.exit 1

# Load/require the file
file = undefined
try	
	filename = process.cwd() + '\\' + process.argv[2]
	l "[+] Requiring file: " + filename
	file = require filename
catch e
	l "[-] Error requiring file: " + e
	process.exit 1

# Reduce siteIds into products array
products = Object.keys(file.sites).reduce ((prev, current) ->
	# Grab the cart
	retailerCart = file.sites[current].add_to_cart
	if !retailerCart
		return prev
	# Flatten products out into a single array
	prev.concat Object.keys(retailerCart).map (productid) -> retailerCart[productid]
), []

# Write products out to file
output = undefined
try
	# Get the output filename
	output = process.cwd() + '\\' + process.argv[3]

	# Write the result to file
	fs.writeFile output, "module.exports=" + j(products), (e) ->		
		if e					
			l "[-] Error writing file: " + e
			process.exit 1

		l "[+] Wrote " + products.length + " products to " + output
		process.exit 0
catch e
	l "[-] Error writing file: " + e
	process.exit 1
