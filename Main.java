import java.io.InputStreamReader;
import java.io.BufferedReader;
import java_cup.runtime.*;

class Main {

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
            a = a.substring(0, a.length() - 1);  // remove last character
        }
        // Feed entire input to a single parser
        parser p = new parser(new Yylex(new java.io.StringReader(a)));

        try {
            p.parse();  // parse all input at once
        } catch (Exception e) {
            System.out.println("Syntax error: " + e.getMessage());
        }

        System.out.println("Bye!");
    }

}
