# Makefile for JFlex + CUP arithmetic parser with output directory

# Java compiler and runtime
JAVAC = javac
JAVA  = java

# CUP and JFlex paths
JFLEX = ./jflex-1.9.1/bin/jflex
CUP   = java -jar java-cup-11b.jar

# Input files
LEXER  = Lexer.jflex
PARSER = Parser.cup
MAIN   = Main.java

# Output directory
OUTDIR = output

# Generated files in output
YLEX       = $(OUTDIR)/Yylex.java
PARSER_JAVA = $(OUTDIR)/parser.java
SYM_JAVA   = $(OUTDIR)/sym.java

# Runtime classpath (CUP runtime + output dir)
CP = $(OUTDIR):./java-cup-11b-runtime.jar

# Default target: build everything and run
all: run

# Create output directory if it doesn't exist
$(OUTDIR):
	mkdir -p $(OUTDIR)

# Generate lexer
$(YLEX): $(LEXER) | $(OUTDIR)
	$(JFLEX) -d $(OUTDIR) $(LEXER)

# Generate parser
$(PARSER_JAVA) $(SYM_JAVA): $(PARSER) | $(OUTDIR)
	$(CUP) -destdir $(OUTDIR) $(PARSER)

# Compile all Java files in output
# Compile all Java files in output
compile: $(YLEX) $(PARSER_JAVA) $(SYM_JAVA)
	$(JAVAC) -d $(OUTDIR) -cp $(CP) $(OUTDIR)/*.java $(MAIN)


# Run the main program
# Run the main program
run: compile
	$(JAVA) -cp $(OUTDIR):./java-cup-11b-runtime.jar Main


# Clean generated files
clean:
	rm -rf $(OUTDIR)/*.java $(OUTDIR)/*.class

