import java.io.InputStreamReader;
import java.io.BufferedReader;
import java_cup.runtime.*;
import java.util.Map;
import java.util.HashMap;
import java.util.function.Supplier;
import java.util.List;
import java.util.ArrayList;

class Main {

    public static class Result {
        public final String output;
        public final boolean isError;

        public Result(String output, boolean isError) {
            this.output = output;
            this.isError = isError;
        }

        public static Result ok(String output) {
            return new Result(output, false);
        }

        public static Result error(String output) {
            return new Result(output, true);
        }

        public boolean isEmpty() {
            return this.output.isEmpty();
        }
    }

    public static void main(String[] args) throws Exception {

        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        StringBuilder input = new StringBuilder();
        String line;

        System.out.println("Enter expressions or commands (Ctrl+D to finish):");

        // Read all lines until EOF (Ctrl+D)
        while ((line = reader.readLine()) != null) {
            input.append(line).append("\n");  // keep newlines for CUP
        }
        String a = input.toString();

        // Check if string is not empty
        if (!a.isEmpty()) {
            a = a.substring(0, a.length() - 1);  // remove last newline
        }

        // Feed entire input to a single parser
        parser p = new parser(new Yylex(new java.io.StringReader(a)));

        try {
            // Parse the input
            Symbol result = p.parse();  // parse returns a Symbol

            // Get the value from the Symbol (which should be a Supplier<parser.Result>)
            if (result.value != null) {
                @SuppressWarnings("unchecked")
                Supplier<parser.Result> program = (Supplier<parser.Result>) result.value;

                // Execute the program
                program.get();
            }
        } catch (Exception e) {
            System.out.println("Syntax error: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("Bye!");
    }

}