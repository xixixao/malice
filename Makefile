CoffeeScript = node_modules/coffee-script/bin/coffee
MetaCoffee = node_modules/metacoffee/node/metacoffee
SRCDIR = src
BUILDIR = bin
coffees = $(wildcard $(SRCDIR)/*.coffee)
javascripts = $(patsubst $(SRCDIR)/%.coffee, $(BUILDIR)/%.js, $(coffees))

all: $(javascripts) parser semantics

.PHONY: all clean

$(BUILDIR)/%.js : $(SRCDIR)/%.coffee
	$(CoffeeScript) -c -o $(BUILDIR) $<

parser:
	$(MetaCoffee) $(BUILDIR) $(SRCDIR)/parser.metacoffee

semantics:
	$(MetaCoffee) $(BUILDIR) $(SRCDIR)/semantics.metacoffee

clean:
	rm $(BUILDIR)/*.js