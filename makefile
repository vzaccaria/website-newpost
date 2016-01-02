
index.js: index.ls
	echo '#!/usr/bin/env node --harmony' > $@
	lsc -p -c $<  >> $@
	chmod +x $@

clean:
	rm index.js