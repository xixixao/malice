CoffeeScript = node_modules/coffee-script/bin/coffee
MetaCoffee   = node_modules/metacoffee/node/metacoffee
SRCDIR       = src
BINDIR       = bin
coffees      = $(wildcard $(SRCDIR)/*.coffee)
javascripts  = $(patsubst $(SRCDIR)/%.coffee, $(BINDIR)/%.js, $(coffees))

all: $(javascripts) parser semantics

.PHONY: all clean parser semantics

$(BINDIR)/%.js : $(SRCDIR)/%.coffee
	$(CoffeeScript) -c -o $(BINDIR) $<

parser: $(BINDIR)/parser.js

$(BINDIR)/parser.js: $(SRCDIR)/parser.metacoffee
	$(MetaCoffee) $(BINDIR) $<

semantics: $(BINDIR)/semantics.js

$(BINDIR)/semantics.js: $(SRCDIR)/semantics.metacoffee
	$(MetaCoffee) $(BINDIR) $<

clean:
	rm $(BINDIR)/*.js