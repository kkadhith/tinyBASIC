# TinyBASIC

BASIC is a custom programming language compiled with our custom compiler, Caveman. We use GNU Bison to process our custom CFGs and Lex to parse tokens. You can find examples of using our language in the examples directory. 

#### Language & Compiler Specification

- Programming Language Name: **BASIC**
- Extension: **.simp**
- Compiler Name: **Caveman**

###### Language Features and Code Examples

| Language Feature | Code Example | 
| --------------- | --------------- | 
| Integer scalar variable | `var : int; var, otherVar : int;`| 
| One Dimensional Arrays of Integers | `a = array[1000] type int;` | 
| Assignment statements | `var ?= 10;`| 
| Arithmetic operators  | `+`,`-`,`*`,`/` |  
| Comparison operators  | `<,<=,==,>,>=,!=`| 
| While Loops | `while (i < n) beginwhile`<br /> `    doSomething`<br /> `endloop;` | 
| If-then-else statements  | `if (i < n) then` <br /> `    doSomething`<br /> `endif` <br /> `else then` <br /> `    doSomethingElse` <br /> `endelse` | 
| Read and Write statements  | `input n;`, `print n;` | 
| Comments   | `$comment` | 
| Functions with multiple parameters and return exactly one single scalar result | `function sumOfTwoNumbersPlusFive;`<br /> `beginparams` <br /> `endparams` <br /> `beginlocals` <br /> `a = int;` <br /> `b = int;` <br /> `endlocals` <br /> `beginfuncbody` <br /> `    input a;` <br /> `    input b;`<br /> `    return a + b + 5;` <br /> `endbody` | 

###### Language Symbols and Token Names

| Symbol in Language | Token Name | 
| --------------- | --------------- | 
|`;` | SEMICOLON | 
|`:` | COLON | 
| `int` | INT | 
| `==` | EQUALS | 
| `array` | ARRAY | 
| `function` | FUNCTION | 
| `return` | RETURN |
| `?=` | ASSIGN| 
| `type` | TYPE|
| `+` | ADD| 
| `-` | SUBTRACT| 
| `*` | MULT| 
| `/` | DIV|
| `true` | TRUE|
| `false` | FALSE|
| `<` | LESS_THAN|
| `<=` | LESS_THAN_EQ|
| `>` | GREAT_THAN|
| `>=` | GREAT_THAN_EQ|
| `!=` | NOT_EQ|
| `$` | (No token, this is a comment)| 
| `(` | LEFT_PAREN| 
| `)` | RIGHT_PAREN| 
| `[` | LEFT_SQUARE_BRACKET| 
| `]` | RIGHT_SQUARE_BRACKET| 
| `newline` | NEWLINE| 
| `input` | READ| 
| `print` | WRITE| 
| `beginwhile` | BEGIN_LOOP| 
| `endwhile` | END_LOOP| 
| `beginparams` | BEGIN_PARAMS| 
| `endparams` | END_PARAMS| 
| `beginfuncbody` | BEGIN_FUNC_BODY| 
| `endfuncbody` | END_FUNC_BODY|
| `beginlocals` | BEGIN_LOCAL_VAR| 
| `endlocals` | END_LOCAL_VAR| 
| `(Identifier like a, b, etc.)` | IDENT XXXXX| 
| `Number (like 1, 2, 3)` | NUM X| 
| `if` | IF | 
| `else` | ELSE |
| `then` | THEN | 
| `endif` | END_IF | 
| `while` | WHILE |
| `ff` | BREAK |

#### Comments

- Comments start after `$` and end after a newline. Comments can begin on any line, and only the characters after the `$` will be ignored. 

#### Valid Identifiers

- Identifiers must begin with an alphabet character. The identifier can include a number and/or lowercase/uppercase letters. However, identifiers cannoot contain special characters. For instance, `abc : int` and `h3lLo : int` would be accepted, but the following would not: <br /> `@bc : int`<br /> `h@llo : int`.

#### Case Sensitivity

- Our language is case sensitive. Identifiers will not match with identifiers that have the same letters, but different case. For example: <br /> 
`hello : int`<br /> 
`Hello = 1`<br /> 

The above would throw an error because the `h` is different.

Additionally, keywords are case sensitive. Declaring an integer can only be done by using `int`, and not `Int`.

#### Whitespace

- Our language ignores whitespace in most cases. For example, the following block of code would be valid:
```
function doSomething; beginparams endparams beginlocals endlocals beginfuncbody return 3; endbody
```
Would be valid, and `doSomething` would still return 3.

One case where whitespace is ignored is comments (as specified earlier). Everything that comes after a `$` will be ignored. 
