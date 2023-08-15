---
source: https://phoenixonrails.com
title: Phoenix on Rails
---

## 1. Intro  

Using [asdf-vm/asdf-elixir: Elixir plugin for asdf version manager](https://github.com/asdf-vm/asdf-elixir)

:dog: 

<details><summary>:ship: Install Elixir/Erlang w/ asdf</summary>

- `asdf install elixir 1.15.4-otp-25`
- `asdf install erlang 25.3.2.5       # VSCode elixirLS does not support OTP 26`
- `mix local.hex`
- `mix archive.install hex phx_new`
- `mix phx.new --version` # => Phoenix installer v1.7.7
- [PostgreSQL - Detailed installation guides](https://wiki.postgresql.org/wiki/Detailed_installation_guides)
  - `sudo apt-get install postgresql postgresql-contrib postgresql-client`
  - `sudo service postgresql start` # For WSL
  - `sudo -u postgres psql postgres`

</details>

## Part 1. An introduction to Elixir

### 2. Ruby vs. Elixir  

|                | Elixir                                      | Ruby                                                       |
| ---            | ---                                         | ---                                                        |
| paradigm       | Functional (w/ Modules)                                  | Object-oriented                                            |
| Console        | `iex` (Press `Ctrl + C` twice to exit)      | `irb` (Press `Ctrl + D` to exit)                           |
| Mutability     | Everything is immutable                     | Some (strings) are mutable, others (symbols) are immutable |
| File extension | `.ex` or `.exs`                             | `.rb`                                                      |
| Execution      | Compile `.ex` files, interpret `.exs` files | Interpreted                                                |


<details><summary>Code</summary>

In Elixir, everything behaves like a Ruby symbol. There’s no equivalent of
`capitalize!` on a Elixir string because Elixir __can’t mutate the string__ in
place.

```elixir
String.upcase(name) # vs Ruby: name.upcase
```

Compile and Excute

```bash
elixirc math.ex # creates Elixir.Math.Bem
elixir math.exs # Doesn't save .beam
```
</details>

### 3. Basic Elixir Syntax  

Just remember that:
- Strings must use double quotes, not single quotes.
- Functions and `if/unless` must have a do on their opening lines.
- There are no `return` or `elsif` keywords.


<details><summary>Common Syntax</summary>

```elixir
IO.puts("Hello, world!")

  # Vars
some_number = 1
  # variable names can end with ? or !:
valid? = true 
password! = "foobar"

  # Strings
"Hello" <> " " <> "there" # contat
"The name's #{name}"      # interpolate

  # No multiline comments

  # Conditionals
unless age >= 18 do
  "Minor"
else
  "Adult"
end

  # blocks are scoped
x = "Something"
if true do
  x = "Something else"
end
x #=> "Something"

  # return value to assign
x = if true do
  "Something"
else
  "Something else"
end
x #=>"Something"

  # No elsif
cond do
  age >= 18 -> "Adult"
  age >= 13 -> "Teenager"
  true -> "Child"           # fallback clause
end

  # for loops are expressions that return a value
squares = for n <- [1,2,3,4] do
  n * n
end
IO.puts squares #=> [1,4,9,16]

  # Math
5/2       # => 2.5
div(5,2)  # => 2 
rem(6,4)  # => 2
2 ** 4    # => 16
floor; ceil; round; abs; max; min;

  # equals vs exactly equals...
2 ==  2   # true
2 === 2   # true
2 ==  2.0 # true
2 === 2.0 # false

```
[Comprehensions - The Elixir programming language](https://elixir-lang.org/getting-started/comprehensions.html)
- sytactic sugar for looping over enumerables
- have 3 parts: generators, filters, and collectables
</details>

<details><summary>Functions</summary>

```elixir
  # Elixir doesn’t have a return statement. 
  # You can’t “exit early” from an Elixir function - 
  # the only way to return something is to make it be the 
  # value of the function’s final expression.
def add(a, b) do

  # Default argument
def choose_color(color \\ "black") do

  # By convention, functions with ? return a bool
String.contains?("England", "gland")

  # And functions that end an ! raise an exception in their error cases
File.read("file_that_doesnt_exist.txt") # => {:error, :enoent}
File.read!("file_that_doesnt_exist.txt") 
  # => ** (File.Error) could not read file 
  # => file_that_doesnt_exist.txt: no such file or directory

  # Anonymous Fn
fn x, y ->
  x + y
end

sum = fn x, y -> x + y end    # call with '.'
sum.(1, 2)                    # => 3

  # Can be passed as argument to other fns
Enum.map([1, 2, 3, 4], fn n -> n ** 2 end)          # => [1, 4, 9, 16]
Enum.reduce([1, 2, 3, 4], fn x, acc -> x + acc end) # => 10
                            
  # Shorthand syntax for anonymous fns
sum1= fn x, y -> x + y end
sum2 = &(&1 + &2)           # Is equivalent to previous line
sum2.(3,4)                  # => 7

sum3 = & &1 + &2            # The brackets are optional:
sum3.(3,4)                  # => 7 

Enum.map([1, 2, 3, 4], &(&1 ** 2))    # => [1, 4, 9, 16]
Enum.reduce([1, 2, 3, 4], &(&1 + &2)) # => 10

```

</details>
<details><summary>Regex</summary>

```elixir
  # Regex
Regex.match?(~r/se[0-9]en/, "se7en") # => true
  # These are all equivalent:
~r/se[0-9]en/
~r(se[0-9]en)
~r'se[0-9]en'

```

</details>
<details><summary>Inspect & Exceptions</summary>

```elixir

  # inspect
puts :symbol  # => symbol
p :symbol     # => :symbol

  # p == IO.inspect
IO.puts "string"    # => string
IO.inspect "string" # => "string"

  # Exceptions
raise "something's wrong!" # => ** (RuntimeError) something's wrong!

try do
  raise "something's wrong"
rescue
  e in RuntimeError -> e.message
end                               # => "something's wrong"

try do  # code that might raise an exception
rescue  # code that handles the error
else    # code that only executes if there was no error
after   # code that's always executed, whether or not there was an error
end

try do
  throw 1
catch
  x -> "#{x} was caught"
end                       # => "1 was caught"

  # There’s almost always a better, more readable way to solve a problem 
  # than with throw and catch. 
  # Don’t use them unless you truly have no other choice!

defmodule Foo do
  def bar do
    raise "something's wrong"
  rescue
    RuntimeError -> "rescued error"
  end
end
Foo.bar   # => "rescued error"

```

</details>

### 4. Elixir Modules  

<details><summary>Modules organize functions</summary>

```elixir
defmodule Math do
  def add(a, b) do
    a + b
  end

  def subtract(a, b) do
    a - b
  end
end
```
</details>

<details><summary>Import (only)</summary>

```elixir
import Math
add(2, 2)       #> 4
subtract(5, 3)  #> 2

import Math, only: [add: 2]
```
</details>

<details><summary>Private</summary>

_No protected methods_. `defp` for private

```elixir
defmodule Math do
  defp add(a, b) do
    a + b
  end
end
```
</details>

<details><summary>Alias</summary>

```elixir
alias Math, as: M
M.add(2, 2)     #> 4

defmodule PhoenixOnRails.Multiplication do ... end
alias PhoenixOnRails.Multiplication # Now we can just refer to `Multiplication` without using its full name:
Multiplication.multiply(3, 4)       #> 12

  # Instead of writing this on separate lines:
alias PhoenixOnRails.Foo
alias PhoenixOnRails.Bar
alias PhoenixOnRails.Fizz
alias PhoenixOnRails.Buzz

  # You can write it like this:
alias PhoenixOnRails.{Foo, Bar, Fizz, Buzz}
```
</details>

<details><summary>Recap</summary>

| Module                     | Ruby                                         | Elixir                                                       |
| ---                        | ---                                          | ---                                                          |
| create a module            | `module`                                     | `defmodule`                                                  |
| using a module’s functions | mix in to a class with `include` or `extend` | call directly e.g. `Math.add(2, 2)`, or import with `import` |
| private functions          | `private`                                    | `defp`                                                       |
| protected functions        | `protected`                                  | don’t exist                                                  |

| Alias                       | Result                                                           |
| ---                         | ---                                                              |
| `alias Foo.Bar, as: Bar`    | adds `Bar` as alternative name for `Foo`                         |
| `alias Foo.Bar`             | shorthand for `alias Foo.Bar, as: Bar`                           |
| `alias Foo.{Bar, Car, Dar}` | shorthand for `alias Foo.Bar`, `alias Foo.Car`, `alias Foo.Dar`. |

</details>

### 5. Atoms, Lists and Tuples  

<details><summary>Atoms</summary>

Atoms are never garbage collected.

```elixir
:like_this
:"like_this"
:'like_this'
```
</details>

<details><summary>Lists </summary>

Implemented as _linked lists_.

```elixir
[3.14, "Hello", :hola, 456, false]
["foo", "bar"] ++ ["fizz", "buzz"]  # ["foo", "bar", "fizz", "buzz"]
["foo", "bar"] -- ["foo"]           # ["bar"]

hd ["foo", "bar", "fizz", "buzz"] # "foo"
tl ["foo", "bar", "fizz", "buzz"] # ["bar", "fizz", "buzz"]
tl ["foo"]      # [] # The tail of a one-element list is the empty list:

length ["James", "Kirk", "Lars", "Robert"]    # 4
"Kirk" in ["James", "Kirk", "Lars", "Robert"] # true

List.starts_with?([1, 1, 2, 3, 5, 8], [1, 1])   # true
Enum.at(["James", "Kirk", "Lars", "Robert"], 2) # "Lars"

  # [head | tail]
[0 | [1,2,3,4]] # [0, 1, 2, 3, 4]
["foo" | []]    # ["foo"]
```
</details>

<details><summary>Tuples </summary>

Tuples are fixed-size, ordered containers of elements.

```elixir
{"Biden", "president@whitehouse.gov"}

elem {"Biden", "president@whitehouse.gov"}, 0 # "Biden"
elem {"Biden", "president@whitehouse.gov"}, 1 # "president@whitehouse.gov"

  # commonly used in function return with status
File.read("file_that_exists.txt")       # {:ok, "this is the file's contents"}
File.read("file_that_doesnt_exist.txt") # {:error, :enoent}
```
</details>

<details><summary>Lists vs. Tuples</summary>

- Tuples are _contiguous in memory_. A tuple takes up a fixed, known amount of
  memory, and accessing a tuple element by its index will always run in
  constant time.
  - If you know exactly _how many elements you want to store, and this number won’t change_, then you probably want a tuple. 
- Lists, on the other hand, are represented internally as _linked lists_. This
  means that to get an element from a list, you must traverse the list’s
  elements one by one, which can be slow if the list is long.
  - Lists are better suited when the _number of elements is variable_ or not known in advance.

```elixir
president_tuple = {"Biden", "president@whitehouse.gov"}
president_list  = ["Biden", "president@whitehouse.gov"]

Tuple.to_list({1,2,3}) # [1, 2, 3]
List.to_tuple([1,2,3]) # {1, 2, 3}
```
</details>

<details><summary> Size vs Length</summary>

- Since tuples are contiguous in memory, Elixir knows in advance how big it is
  and can return the size in constant time, __O(1)__
- To calculate the length of a list, however, Elixir needs to traverse the
  whole list and count its elements one by one, in linear time, __O(n)__

```elixir
tuple_size({5, 1, 4})     # 3
length(["fizz", "buzz"])  # 2
```
</details>

<details><summary>Recap</summary>

- Elixir **atoms** are essentially the same thing as Ruby **symbols** and use
  the `:same_syntax`.
- Elixir **lists** are written with square brackets (`[`, `]`) and are
  internally represented as linked lists.
- Elixir **tuples** are written with curly braces (`{`, `}`) and are stored as
  contiguous blocks of memory. They have no direct equivalent in Ruby.
- Use tuples for compound values and fixed-size collections, and use lists for
  sequences of data of indeterminate size.
- `tuple_size/1` counts the number of elements in a tuple and runs in constant
  time. `length/1` counts the number of elements in a list and runs in time
  linear to the length of the list.
- `String.length/1` returns the number of characters in a string.
</details>

### 6. Sigils  

|                              |  Elixir                                  |  Ruby                   |
| --                           |  --                                      |  --                     |
| String (with interpolation)  |  `~s(…)`                                 |  `%(…)` or `%Q(…)`      |
| String (no interpolation)    |  `~S(…)`                                 |  `%q(…)`                |
| Array of strings             |  `~w(…)`                                 |  `%w(…)`                |
| Array of symbols/atoms       |  `~w(…)a`                                |  `%i(…)`                |
| Regex                        |  `~r(…)`                                 |  `%r(…)` or just /…/    |
| Delimiter                    |  8 options `//  ||  ""  '' () [] {} <>`  |  any symbol             |
| Interpolation with #{}       |  lowercase e.g. `~w[…]`                  |  uppercase e.g. `%W[…]` |

<details><summary>Code</summary>

```elixir
~w[crash bang wallop] #> ["crash", "bang", "wallop"]

~w[crash bang wallop]a #> [:crash, :bang, :wallop]
                       # In Elixir use ~w[…]a to create an array of atoms. 
                       # That is, use the same syntax as for an array of strings, 
                       # but _add an a_ after the closing delimiter:

~w/crash bang wallop/ # ONLY theseeight lines create the array:
~w|crash bang wallop| # Unlike Ruby (which can use any delimiter)
~w"crash bang wallop"
~w'crash bang wallop'
~w(crash bang wallop)
~w[crash bang wallop]
~w{crash bang wallop}
~w<crash bang wallop>

Regex.match?(~r/se[0-9]en/, "se7en") # ~r creates regex
 # Your choice of delimiter affects which characters must be escaped with \.
 # For example, to write a regex that matches the string http//, 
 # you might not want to use / as your delimiter, 
 # because then you’d need to write ~r/^https?\/\//, which is a bit hard to read.
 # With a different delimiter you don’t need to escape the slashes; 
 # e.g. you could write ~r(^https?//).

~s(This is a string) #> "This is a string"
 # Sigil, no need for escape characters:
~s(He said "I'm not sure") 
 # Equivalent with escaped double quotes: "He said \"I'm not sure\""

  # To create a multiline string, called a heredoc, use ~s with three double or single quotes:
haiku = ~s"""
        Elixir code flows free,
        Functional charm in each line,
        Concurrency thrives.
        """ 
        #> "Elixir code flows free,\nFunctional charm in each line,\nConcurrency thrives.\n"

  # Note that the heredoc removes the opening indentation from each line:
IO.puts(haiku)
  #> Elixir code flows free,
  #> Functional charm in each line,
  #> Concurrency thrives.

 # Sigils allow you to interpolate data using #{}, just like a string. 
 # Alternatively, if you use the capitalized version of the sigil (e.g. ~S), 
 # interpolation will be ignored:
noun = "mat" #> "mat"

~s(The cat sat on the #{noun}) #> "The cat sat on the mat"

~S(The cat sat on the #{noun}) #> "The cat sat on the \#{noun}"
```
</details>

### 7. Pattern matching  

- Allows to assign more than one variable at once
- e.g. with tuples or lists
- can be used in `case`
- allows pattern matching function params
- `match/2`

<details><summary>Code</summary>

```elixir
{x, y} = {1, 2}

list = [1,2,3]
[a, b, c] = list

{x, y} = {1, 2, 3}  #> ** (MatchError) no match of right hand side value: {1, 2, 3}
{x, x} = {10, 11}   #> ** (MatchError) no match of right hand side value: {10, 11}

[head | tail] = ["a", "b", "c", "d"]
head #> "a"
tail #> ["b", "c", "d"]

[1 | tail] = [1, 1, 2, 3, 5]    
tail                            #> [1, 2, 3, 5]
[1 | tail] = [2, 3, 5, 7, 11]   #> ** (MatchError) no match of right hand side value: [2, 3, 5, 7, 11]

{x, 2} = {1, 2}
x               #> 1
{x, 2} = {1, 3} #> ** (MatchError) no match of right hand side value: {1, 3}

{x, _, _} = {1, 2, 3}   # _ cannot be read
x                       #> 1
_      #> ** (CompileError) iex:9: invalid use of _. "_" represents a value to be ignored in a pattern and cannot be used in expressions

n = 1 #> 1
1 = n #> 1
2 = n #> ** (MatchError) no match of right hand side value: 1
n = 2 #> 2
2 = z #> ** (CompileError) iex:3: undefined function z/0 (there is no such import)

 # A limitation of pattern matching is that you can’t make function calls on the left-hand side of =:
length([1,2]) = 2 #> ** (CompileError) iex:4: cannot invoke remote function :erlang.length/1 inside a match

 # Pin operator
president = "Biden"
{president, veep} = {"Trump", "Pence"}
president   #> "Trump"
{^president, veep} = {"Biden", "Harris"}
veep        #> "Harris"
{^president, veep} = {"Trump", "Pence"} #> ** (MatchError) no match of right hand side value: {"Trump", "Pence"}

  # Case statement
case {"Theodore", "Roosevelt"} do
  {"Franklin", "Roosevelt"}  -> "This clause won't match"
  {"Abraham", "Lincoln"}     -> "Neither will this"
  {firstname, "Roosevelt"}   -> "This matches and binds \"Theodore\" to the variable 'firstname'"
  {"Theodore", lastname}     -> "This doesn't get evaluated because we already found a match above"
  _                          -> "This is a failsafe clause that matches anything."
end

  # Pattern-matching on function parameters
defmodule Recursor do
  def sum(list) do
    case list do
      [] -> 0
      [head | tail] -> head + sum(tail)
    end
  end
end
  # Is the same as...
defmodule Recursor do
  def sum([]) do
    0
  end
  def sum([head | tail]) do
    head + sum(tail)
  end
end
IO.puts Recursor.sum([1,2,3,4]) #> 10
IO.puts Recursor.sum([1,4,7,1]) #> 13

  # Match on function param
defmodule Translator do
  def color("blue") do; "azul"; end
  def color("red") do; "rojo"; end
end
Translator.color("mauve") #> => ** (FunctionClauseError) no function clause matching in Translator.color/1

  # Can use Guard in fn clause
defmodule Math do
  def zero?(0) do;                      true; end
  def zero?(x) when is_integer(x) do;   false; end
end
IO.puts Math.zero?(0)         #=> true
IO.puts Math.zero?(1)         #=> false
IO.puts Math.zero?([1, 2, 3]) #=> ** (FunctionClauseError)
IO.puts Math.zero?(0.0)       #=> ** (FunctionClauseError)

  # Match
match?(%{a: 1}, %{a: 1, b: 2}) #> true
match?(%{a: 2}, %{a: 1, b: 2}) #> false

match?(x, 5) #> warning: variable "x" is unused (if the variable is not meant to be used, prefix it with an underscore)
             #> true
  # Can use pinned variable to get rid of warning
x = 6
match?(%{a: ^x}, %{a: 6}) #> true
```
</details>

### 8. Elixir Maps  

- Are _key-value_ data structures similar to Ruby hashes.
- Are written with `%{}`, as opposed to Ruby hashes which are written with `{}`.
- Can be updated with the special syntax `%{map| key: value}`.
- Can be accessed using `[]` (returns `nil` if key not found) 
- or `.` syntax (atom keys only; raises an error if key not found.)

<details><summary>Code</summary>

```elixir
foo = %{ a: 1, b: 2 }
foo[:a] #> 1
my_map = %{ 1 => "a", "x" => "b", [] => "c", 3.5 => "d" } #> Anything can be a key

%{ a: 1, b: 2 } # is the same as
%{ :a => 1, :b => 2 }

  # Pattern match on maps
%{name: name} =  %{name: "Harry"}
name #> "Harry"
%{name: name, house: "Slytherin"} =  %{name: "Harry", house: "Gryffindor"} #> ** (MatchError) no match of right hand side value: %{house: "Gryffindor", name: "Harry"}

  # Keys must be on left, but optional on right
  # This matches; additional keys other than 'name' are ignored:
%{name: name} =  %{name: "Harry", house: "Gryffindor", broomstick: "Nimbus 2000"}
name #> "Harry"
  # This is a MatchError because the :house key is missing on the right:
%{name: name, house: house} =  %{name: "Harry"} #> ** (MatchError) no match of right hand side value: %{name: "Harry"}

  # Can assign whole map and pattern match vars
def func(%{foo: foo, bar: bar} = map) do
  IO.puts foo; IO.puts bar; IO.inspect map
end

func(%{foo: 1, bar: 2})
  #> 1
  #> 2
  #> %{bar: 2, foo: 1}

  # Common Map functions
map_size(%{a: 1, b: 2, c: 3})
Map.get(%{a: 1, b: 2}, :a)
Map.put(%{a: 1, b: 2}, :c, 3)
Map.keys(%{a: 1, b: 2})
Map.values(%{a: 1, b: 2})
Map.merge(%{a: 1, b: 2}, %{b: 3, c: 4}) #> %{a: 1, b: 3, c: 4}

  # Update maps
foo = %{a: 1, b: 2}
%{ foo | b: 3 }         #> %{a: 1, b: 3}

  # This syntax can only update an existing key, not add a new one. 
foo = %{a: 1, b: 2}
%{ foo | c: 3 }         #> ** (KeyError) key :c not found in: %{a: 1, b: 2}

  # Can use . syntax
foo = %{a: 1, b: 2}
foo.a                   #> 1

  # But only on atoms
foo = %{"a" => 1}
foo.a                   #> ** (KeyError) key :a not found in: %{"a" => 1}

```
</details>

### 9. Keyword Lists  

- Maps (and Keyword) are what’s called an _associative data structure_ - they associate keys to values.
- Are syntactic sugar over lists of two-element tuples.
- written with `[ ... ]`
- Can have duplicate keys.
- Can be manipulated using all the normal list operations and functions, as well as by the `Keyword` module.
- Are mainly used for passing a list of options as the last argument to a function (in which case you can leave off the `/`)
- Generally shouldn’t be pattern-matched on.
- Are used to implement `do` blocks, e.g. for `if` and `def`.

<details><summary>Code</summary>

```elixir
kwlist = [foo: 1, bar: 2]

  # Cannot use . syntax
kwlist.foo      #> ** (ArgumentError)

  # Can have duplicate keys
kwlist = [foo: 1, foo: 5, bar: 16, foo: 12]
kwlist[:foo]                                    #> 1

  # Just a list of tuples like `[{ }, {}]
[name: "Bob", age: 25] == [{:name, "Bob"}, {:age, 25}]  #> true

  # List functions work
[foo: 1, bar: 2] ++ [fizz: 3, buzz: 4]
[foo: 1, bar: 2] -- [foo: 1]          
{:foo, 1}       in [foo: 1, bar: 2]         
[{:boo, 0}      | [foo: 1, bar: 2]]
List.first([foo: 1, bar: 2])

  # Are ordered like List
[foo: 1, bar: 2] == [bar: 2, foo: 1] #> false

  # The main thing keyword lists are used for is to pass options to functions.
String.split("I am your father", " ")                   #> ["I", "am", "your", "father"]
  # split/3 has optional args
String.split("I   am your  father", " ", [trim: true])  #> ["I", "am", "your", "father"]
  # if passing single len list, leave off []
String.split("I   am your  father", " ", trim: true)    #> ["I", "am", "your", "father"]

  # When using List as optional params in your fn, 
  # pattern matching is tricky since order is important in List
  # Instead use Keyword funs
Keyword.has_key?([trim: true, parts: false], :something_else)   #> false
Keyword.get(     [trim: true, parts: false], :trim)             #> true
Keyword.fetch(   [trim: true, parts: false], :trim)             #> {:ok, true}
Keyword.fetch(   [trim: true, parts: false], :not_there)        #> :error
Keyword.fetch!(  [trim: true, parts: false], :not_there)        #> ** (KeyError) key :not_there not found in: [trim: true, parts: false]
Keyword.delete(  [trim: true, parts: false], :parts)            #> [trim: true]

  # Allowing duplicate keys is helpful e.g. in `Ecto.Query`
query =
  from b in Book,
    where: b.publication_year < 1990,
    where: b.num_pages > 300,
    where: b.type == "Hardback"
books = Repo.all(query)

  # if is a __macro__ `if/2` with a keyword list for arguments
if some_condition do; "Something"; else; "Something else"; end
  # same as
if some_condition, do: "Something", else: "Something else"
  # same as
if(some_condition, [do: "Something", else: "Something else"])
  # also works for other blocks
def shout(str), do: IO.puts(String.upcase(str))
```
</details>

### 10. Module attributes  
### 11. Elixir Structs  
### 12. Date and time  
### 13. The pipe operator  
## Part 2. A simple CRUD app
### 14. A simple Rails app  
### 15. Creating a new Phoenix app  
### 16. Directory structure and mix.exs  
### 17. Routing and config  
### 18. Controllers and templates  
### 19. Tailwind  
### 20. Embedded Elixir  
### 21. Layouts  
### 22. Phoenix views  
### 23. Ecto.Migration  
### 24. Ecto.Schema  
### 25. Ecto.Repo  
### 26. Route helpers  
### 27. Index page  
### 28. Function components  
### 29. Core components  
### 30. Phoenix contexts  
### 31. Helper functions  
### 32. Ecto.Changeset  
### 33. New and Create  
### 34. Errors and I18n  
### 35. Edit and Update  
### 36. Deleting memories  
### 37. Recap  
## Part 3. Advanced concepts
### 38. Dependency management  
### 39. Erlang libraries  
### 40. use  
### 41. Plug and pipelines  
### 42. Scaffolding  
### 43. with  
### 44. Ecto.Query  
### 45. LiveView  
## Part 4. Twittex
### 46. phx.gen.auth  
### 47. Database indexes  
### 48. The User schema  
### 49. Uniqueness validations  
### 50. User registration  
### 51. User sessions  
### 52. Auth routes and plugs  
### 53. Static files  
### 54. Assets and esbuild  
### 55. Phoenix.Param  
### 56. Associations  
### 57. Preloads  
### 58. Emails and password resets  
### 59. LiveView sessions  
### 60. LiveView forms  
### 61. File uploads  
### 62. Follows  
### Conclusion
