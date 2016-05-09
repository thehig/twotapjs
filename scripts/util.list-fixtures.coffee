l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

l "[+] List Fixtures"
fx = require('./fixtures/list.js')

l "[+] \tFixture Count: " + fx.all_array.length
l "[+] \tFixture Names: " + Object.keys fx.all