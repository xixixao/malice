CoffeeScript   = node_modules/coffee-script/bin/coffee
MetaCoffee     = node_modules/metacoffee/node/metacoffee
SRCDIR         = src
BINDIR         = bin
metacoffees    = $(wildcard $(SRCDIR)/*.metacoffee)
metacoffeesjs  = $(patsubst $(SRCDIR)/%.metacoffee, $(BINDIR)/%.js, $(wildcard $(SRCDIR)/*.metacoffee))
coffees        = $(wildcard $(SRCDIR)/*.coffee)
coffeesjs      = $(patsubst $(SRCDIR)/%.coffee, $(BINDIR)/%.js, $(coffees))

all: $(coffeesjs) $(metacoffeesjs)

.PHONY: all clean parser semantics

$(BINDIR)/%.js : $(SRCDIR)/%.coffee
	$(CoffeeScript) -c -o $(BINDIR) $<

$(BINDIR)/%.js : $(SRCDIR)/%.metacoffee
	$(MetaCoffee) $(BINDIR) $<

clean:
	rm $(BINDIR)/*.js