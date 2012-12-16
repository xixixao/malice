CoffeeScript   = node_modules/coffee-script/bin/coffee
MetaCoffee     = node_modules/metacoffee/node/metacoffee
SRCDIR         = src
BINDIR         = bin
modules        = parse semantics implementation assembly
metacoffees    = $(wildcard $(SRCDIR)/*.metacoffee) $(wildcard $(SRCDIR)/*/*.metacoffee)
metacoffeesjs  = $(patsubst $(SRCDIR)/%.metacoffee, $(BINDIR)/%.js, $(metacoffees))
coffees        = $(wildcard $(SRCDIR)/*.coffee) $(wildcard $(SRCDIR)/*/*.coffee)
coffeesjs      = $(patsubst $(SRCDIR)/%.coffee, $(BINDIR)/%.js, $(coffees))

all: $(coffeesjs) $(metacoffeesjs)

.PHONY: all clean parser semantics

$(BINDIR)/%.js : $(SRCDIR)/%.coffee
	$(CoffeeScript) -c -o $(patsubst $(SRCDIR)/%, $(BINDIR)/%, $(dir $<)) $<

$(BINDIR)/%.js : $(SRCDIR)/%.metacoffee
	$(MetaCoffee) $(patsubst $(SRCDIR)/%, $(BINDIR)/%, $(dir $<)) $<

clean:
	rm $(BINDIR)/*.js