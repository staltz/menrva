all : test

SRC=src/*.js
TESTSRC=test

DISTDIR=dist
DISTPREFIX=menrva

BUNDLESRC=src/menrva.js
BUNDLEDST=$(DISTDIR)/$(DISTPREFIX).standalone.js
BUNDLEVAR=menrva

MINSRC=$(BUNDLEDST)
MINDST=$(DISTDIR)/$(DISTPREFIX).min.js
MINMAP=$(DISTDIR)/$(DISTPREFIX).min.js.map

LJSSRC=src/menrva.js

.PHONY : all test jshint mocha istanbul browserify typify literate version dist

BINDIR=node_modules/.bin

MOCHA=$(BINDIR)/_mocha
ISTANBUL=$(BINDIR)/istanbul
JSHINT=$(BINDIR)/jshint
BROWSERIFY=$(BINDIR)/browserify
UGLIFY=$(BINDIR)/uglifyjs
TYPIFY=$(BINDIR)/typify
LJS=$(BINDIR)/ljs
COVERALLS=$(BINDIR)/coveralls

test : jshint mocha istanbul typify

jshint :
	$(JSHINT) $(SRC)
	$(JSHINT) benchmark
	$(JSHINT) -c .jshintrc.examples examples

mocha : 
	$(MOCHA) --reporter=spec $(TESTSRC)

istanbul :
	$(ISTANBUL) cover $(MOCHA) $(TESTSRC)
	$(ISTANBUL) check-coverage --statements 100 --branches 100 --functions 100

browserify : $(SRC)
	mkdir -p $(DISTDIR)
	$(BROWSERIFY) -s $(BUNDLEVAR) -o $(BUNDLEDST) $(BUNDLESRC)

uglify : browserify $(SRC)
	mkdir -p $(DISTDIR)
	$(UGLIFY) -o $(MINDST) --source-map $(MINMAP) $(MINSRC)

typify :
	$(TYPIFY) $(MOCHA) $(TESTSRC)

literate :
	$(LJS) -c false -o README.md $(LJSSRC)

coveralls :
	if [ ! -z `node --version | grep v0.10` ]; then cat ./coverage/lcov.info | $(COVERALLS); fi

version:
	node scripts/version.js

dist : test version uglify literate
	git clean -fdx -e node_modules
