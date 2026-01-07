JAVAC = javac
JAVA  = java

JFLEX = ./jflex-1.9.1/bin/jflex
CUP   = java -jar java-cup-11b.jar

LEXER  = Lexer.jflex
PARSER = Parser.cup
MAIN   = Main.java

OUTDIR = output

YLEX       = $(OUTDIR)/Yylex.java
PARSER_JAVA = $(OUTDIR)/parser.java
SYM_JAVA   = $(OUTDIR)/sym.java

CP = $(OUTDIR):./java-cup-11b-runtime.jar

all: run

$(OUTDIR):
	mkdir -p $(OUTDIR)

$(YLEX): $(LEXER) | $(OUTDIR)
	$(JFLEX) -d $(OUTDIR) $(LEXER)

$(PARSER_JAVA) $(SYM_JAVA): $(PARSER) | $(OUTDIR)
	$(CUP) -destdir $(OUTDIR) $(PARSER)

compile: $(YLEX) $(PARSER_JAVA) $(SYM_JAVA)
	$(JAVAC) -d $(OUTDIR) -cp $(CP) $(OUTDIR)/*.java $(MAIN)

run: compile
	$(JAVA) -cp $(OUTDIR):./java-cup-11b-runtime.jar Main

clean:
	rm -rf $(OUTDIR)/*.java $(OUTDIR)/*.class

