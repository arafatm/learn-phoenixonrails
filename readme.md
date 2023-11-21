---
source: https://phoenixonrails.com
title: Phoenix on Rails
---

## 1. Intro  

Using [asdf-vm/asdf-elixir: Elixir plugin for asdf version manager](https://github.com/asdf-vm/asdf-elixir)

###### :ship: Install Elixir/Erlang w/ asdf
<details><summary></summary>

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
<details><summary></summary>

#### Recap
<details><summary></summary>

|                | Elixir                                      | Ruby                                                       |
| ---            | ---                                         | ---                                                        |
| paradigm       | Functional (w/ Modules)                                  | Object-oriented                                            |
| Console        | `iex` (Press `Ctrl + C` twice to exit)      | `irb` (Press `Ctrl + D` to exit)                           |
| Mutability     | Everything is immutable                     | Some (strings) are mutable, others (symbols) are immutable |
| File extension | `.ex` or `.exs`                             | `.rb`                                                      |
| Execution      | Compile `.ex` files, interpret `.exs` files | Interpreted                                                |

</details>

#### Code
<details><summary></summary>

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

## 3. Basic Elixir Syntax  

#### Recap
<details><summary></summary>

Just remember that:
- Strings must use double quotes, not single quotes.
- Functions and `if/unless` must have a do on their opening lines.
- There are no `return` or `elsif` keywords.

</details>

#### Common Syntax
<details><summary></summary>

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

#### Functions
<details><summary></summary>

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

#### Regex
<details><summary></summary>
```elixir
  # Regex
Regex.match?(~r/se[0-9]en/, "se7en") # => true
  # These are all equivalent:
~r/se[0-9]en/
~r(se[0-9]en)
~r'se[0-9]en'

```

</details>

#### Inspect & Exceptions
<details><summary></summary>

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

## 4. Elixir Modules  

#### Recap
<details><summary></summary>

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

#### Modules organize functions
<details><summary></summary>

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

#### Import (only)
<details><summary></summary>

```elixir
import Math
add(2, 2)       #=> 4
subtract(5, 3)  #=> 2

import Math, only: [add: 2]
```

</details>

#### Private
<details><summary></summary>

_No protected methods_. `defp` for private

```elixir
defmodule Math do
  defp add(a, b) do
    a + b
  end
end
```

</details>

#### Alias
<details><summary></summary>

```elixir
alias Math, as: M
M.add(2, 2)     #=> 4

defmodule PhoenixOnRails.Multiplication do ... end
alias PhoenixOnRails.Multiplication # Now we can just refer to `Multiplication` without using its full name:
Multiplication.multiply(3, 4)       #=> 12

  # Instead of writing this on separate lines:
alias PhoenixOnRails.Foo
alias PhoenixOnRails.Bar
alias PhoenixOnRails.Fizz
alias PhoenixOnRails.Buzz

  # You can write it like this:
alias PhoenixOnRails.{Foo, Bar, Fizz, Buzz}
```

</details>

## 5. Atoms, Lists and Tuples  

#### Recap
<details><summary></summary>

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

#### Atoms
<details><summary></summary>

Atoms are never garbage collected.

```elixir
:like_this
:"like_this"
:'like_this'
```

</details>

#### Lists 
<details><summary></summary>

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

#### Tuples 
<details><summary></summary>

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

#### Lists vs. Tuples
<details><summary></summary>

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

####  Size vs Length
<details><summary></summary>

- Since tuples are contiguous in memory, Elixir knows in advance how big it is
  and can return the size in constant time, __O(1)__
- To calculate the length of a list, however, Elixir needs to traverse the
  whole list and count its elements one by one, in linear time, __O(n)__

```elixir
tuple_size({5, 1, 4})     # 3
length(["fizz", "buzz"])  # 2
```

</details>

## 6. Sigils  

#### Recap
<details><summary></summary>

|                              |  Elixir                                  |  Ruby                   |
| --                           |  --                                      |  --                     |
| String (with interpolation)  |  `~s(…)`                                 |  `%(…)` or `%Q(…)`      |
| String (no interpolation)    |  `~S(…)`                                 |  `%q(…)`                |
| Array of strings             |  `~w(…)`                                 |  `%w(…)`                |
| Array of symbols/atoms       |  `~w(…)a`                                |  `%i(…)`                |
| Regex                        |  `~r(…)`                                 |  `%r(…)` or just /…/    |
| Delimiter                    |  8 options `//  ||  ""  '' () [] {} <>`  |  any symbol             |
| Interpolation with #{}       |  lowercase e.g. `~w[…]`                  |  uppercase e.g. `%W[…]` |

</details>

#### Code
<details><summary></summary>

```elixir
~w[crash bang wallop] #=> ["crash", "bang", "wallop"]

~w[crash bang wallop]a #=> [:crash, :bang, :wallop]
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

~s(This is a string) #=> "This is a string"
 # Sigil, no need for escape characters:
~s(He said "I'm not sure") 
 # Equivalent with escaped double quotes: "He said \"I'm not sure\""

  # To create a multiline string, called a heredoc, use ~s with three double or single quotes:
haiku = ~s"""
        Elixir code flows free,
        Functional charm in each line,
        Concurrency thrives.
        """ 
        #=> "Elixir code flows free,\nFunctional charm in each line,\nConcurrency thrives.\n"

  # Note that the heredoc removes the opening indentation from each line:
IO.puts(haiku)
  #=> Elixir code flows free,
  #=> Functional charm in each line,
  #=> Concurrency thrives.

 # Sigils allow you to interpolate data using #{}, just like a string. 
 # Alternatively, if you use the capitalized version of the sigil (e.g. ~S), 
 # interpolation will be ignored:
noun = "mat" #=> "mat"

~s(The cat sat on the #{noun}) #=> "The cat sat on the mat"

~S(The cat sat on the #{noun}) #=> "The cat sat on the \#{noun}"
```

</details>

## 7. Pattern matching  

#### Recap
<details><summary></summary>

- Allows to assign more than one variable at once
- e.g. with tuples or lists
- can be used in `case`
- allows pattern matching function params
- `match/2`

</details>

#### Code
<details><summary></summary>

```elixir
{x, y} = {1, 2}

list = [1,2,3]
[a, b, c] = list

{x, y} = {1, 2, 3}  #=> ** (MatchError) no match of right hand side value: {1, 2, 3}
{x, x} = {10, 11}   #=> ** (MatchError) no match of right hand side value: {10, 11}

[head | tail] = ["a", "b", "c", "d"]
head #=> "a"
tail #=> ["b", "c", "d"]

[1 | tail] = [1, 1, 2, 3, 5]    
tail                            #=> [1, 2, 3, 5]
[1 | tail] = [2, 3, 5, 7, 11]   #=> ** (MatchError) no match of right hand side value: [2, 3, 5, 7, 11]

{x, 2} = {1, 2}
x               #=> 1
{x, 2} = {1, 3} #=> ** (MatchError) no match of right hand side value: {1, 3}

{x, _, _} = {1, 2, 3}   # _ cannot be read
x                       #=> 1
_      #=> ** (CompileError) iex:9: invalid use of _. "_" represents a value to be ignored in a pattern and cannot be used in expressions

n = 1 #=> 1
1 = n #=> 1
2 = n #=> ** (MatchError) no match of right hand side value: 1
n = 2 #=> 2
2 = z #=> ** (CompileError) iex:3: undefined function z/0 (there is no such import)

 # A limitation of pattern matching is that you can’t make function calls on the left-hand side of =:
length([1,2]) = 2 #=> ** (CompileError) iex:4: cannot invoke remote function :erlang.length/1 inside a match

 # Pin operator
president = "Biden"
{president, veep} = {"Trump", "Pence"}
president   #=> "Trump"
{^president, veep} = {"Biden", "Harris"}
veep        #=> "Harris"
{^president, veep} = {"Trump", "Pence"} #=> ** (MatchError) no match of right hand side value: {"Trump", "Pence"}

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
IO.puts Recursor.sum([1,2,3,4]) #=> 10
IO.puts Recursor.sum([1,4,7,1]) #=> 13

  # Match on function param
defmodule Translator do
  def color("blue") do; "azul"; end
  def color("red") do; "rojo"; end
end
Translator.color("mauve") #=> => ** (FunctionClauseError) no function clause matching in Translator.color/1

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
match?(%{a: 1}, %{a: 1, b: 2}) #=> true
match?(%{a: 2}, %{a: 1, b: 2}) #=> false

match?(x, 5) #=> warning: variable "x" is unused (if the variable is not meant to be used, prefix it with an underscore)
             #=> true
  # Can use pinned variable to get rid of warning
x = 6
match?(%{a: ^x}, %{a: 6}) #=> true
```

</details>

## 8. Elixir Maps  

#### Recap
<details><summary></summary>

- Are _key-value_ data structures similar to Ruby hashes.
- Are written with `%{}`, as opposed to Ruby hashes which are written with `{}`.
- Can be updated with the special syntax `%{map| key: value}`.
- Can be accessed using `[]` (returns `nil` if key not found) 
- or `.` syntax (atom keys only; raises an error if key not found.)

</details>

#### Code
<details><summary></summary>

```elixir
foo = %{ a: 1, b: 2 }
foo[:a] #=> 1
my_map = %{ 1 => "a", "x" => "b", [] => "c", 3.5 => "d" } #=> Anything can be a key

%{ a: 1, b: 2 } # is the same as
%{ :a => 1, :b => 2 }

  # Pattern match on maps
%{name: name} =  %{name: "Harry"}
name #=> "Harry"
%{name: name, house: "Slytherin"} =  %{name: "Harry", house: "Gryffindor"} #=> ** (MatchError) no match of right hand side value: %{house: "Gryffindor", name: "Harry"}

  # Keys must be on left, but optional on right
  # This matches; additional keys other than 'name' are ignored:
%{name: name} =  %{name: "Harry", house: "Gryffindor", broomstick: "Nimbus 2000"}
name #=> "Harry"
  # This is a MatchError because the :house key is missing on the right:
%{name: name, house: house} =  %{name: "Harry"} #=> ** (MatchError) no match of right hand side value: %{name: "Harry"}

  # Can assign whole map and pattern match vars
def func(%{foo: foo, bar: bar} = map) do
  IO.puts foo; IO.puts bar; IO.inspect map
end

func(%{foo: 1, bar: 2})
  #=> 1
  #=> 2
  #=> %{bar: 2, foo: 1}

  # Common Map functions
map_size(%{a: 1, b: 2, c: 3})
Map.get(%{a: 1, b: 2}, :a)
Map.put(%{a: 1, b: 2}, :c, 3)
Map.keys(%{a: 1, b: 2})
Map.values(%{a: 1, b: 2})
Map.merge(%{a: 1, b: 2}, %{b: 3, c: 4}) #=> %{a: 1, b: 3, c: 4}

  # Update maps
foo = %{a: 1, b: 2}
%{ foo | b: 3 }         #=> %{a: 1, b: 3}

  # This syntax can only update an existing key, not add a new one. 
foo = %{a: 1, b: 2}
%{ foo | c: 3 }         #=> ** (KeyError) key :c not found in: %{a: 1, b: 2}

  # Can use . syntax
foo = %{a: 1, b: 2}
foo.a                   #=> 1

  # But only on atoms
foo = %{"a" => 1}
foo.a                   #=> ** (KeyError) key :a not found in: %{"a" => 1}

```

</details>

## 9. Keyword Lists  

#### Recap
<details><summary></summary>

- Maps (and Keyword) are what’s called an _associative data structure_ - they associate keys to values.
- Are syntactic sugar over lists of two-element tuples.
- written with `[ ... ]`
- Can have duplicate keys.
- Can be manipulated using all the normal list operations and functions, as well as by the `Keyword` module.
- Are mainly used for passing a list of options as the last argument to a function (in which case you can leave off the `/`)
- Generally shouldn’t be pattern-matched on.
- Are used to implement `do` blocks, e.g. for `if` and `def`.

</details>

#### Code
<details><summary></summary>

```elixir
kwlist = [foo: 1, bar: 2]

  # Cannot use . syntax
kwlist.foo      #=> ** (ArgumentError)

  # Can have duplicate keys
kwlist = [foo: 1, foo: 5, bar: 16, foo: 12]
kwlist[:foo]                                    #=> 1

  # Just a list of tuples like `[{ }, {}]
[name: "Bob", age: 25] == [{:name, "Bob"}, {:age, 25}]  #=> true

  # List functions work
[foo: 1, bar: 2] ++ [fizz: 3, buzz: 4]
[foo: 1, bar: 2] -- [foo: 1]          
{:foo, 1}       in [foo: 1, bar: 2]         
[{:boo, 0}      | [foo: 1, bar: 2]]
List.first([foo: 1, bar: 2])

  # Are ordered like List
[foo: 1, bar: 2] == [bar: 2, foo: 1] #=> false

  # The main thing keyword lists are used for is to pass options to functions.
String.split("I am your father", " ")                   #=> ["I", "am", "your", "father"]
  # split/3 has optional args
String.split("I   am your  father", " ", [trim: true])  #=> ["I", "am", "your", "father"]
  # if passing single len list, leave off []
String.split("I   am your  father", " ", trim: true)    #=> ["I", "am", "your", "father"]

  # When using List as optional params in your fn, 
  # pattern matching is tricky since order is important in List
  # Instead use Keyword funs
Keyword.has_key?([trim: true, parts: false], :something_else)   #=> false
Keyword.get(     [trim: true, parts: false], :trim)             #=> true
Keyword.fetch(   [trim: true, parts: false], :trim)             #=> {:ok, true}
Keyword.fetch(   [trim: true, parts: false], :not_there)        #=> :error
Keyword.fetch!(  [trim: true, parts: false], :not_there)        #=> ** (KeyError) key :not_there not found in: [trim: true, parts: false]
Keyword.delete(  [trim: true, parts: false], :parts)            #=> [trim: true]

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

</details>

### 10. Module attributes  
<details><summary></summary>

#### Recap
<details><summary></summary>

- Define module attributes with this syntax: `@name "value"`.
- Module attributes are evaluated at compile time.
- Repeating a module attribute reassigns it, unless you configure it to accumulate with 
  `Module.register_attribute __MODULE__, :attr_name, accumulate: true`.
- Use `@moduledoc` and `@doc` to document your modules and functions.

</details>

#### Code
<details><summary></summary>

```elixir
defmodule MyModule do
  @my_attribute "some value"
end

  # used to reduce repetition and make your code more readable
defmodule Circle do
  @pi 3.14159

  def diameter(r), do: 2 * @pi * r
  def area(r),  do: @pi * r ** 2 # evaluated at compile time, same as 
                                 # def area(r), do: 3.14158 * r  ** 2
end

  # Can be reassigned
defmodule MyModule do
  @foo 4; @foo 8; def foo, do: @foo 
end
MyModule.first_foo #> 8

  # Can be accumulated
defmodule MyModule do
  Module.register_attribute __MODULE__, :foo, accumulate: true
  @foo 4; @foo 8; def foo, do: @foo 
end
MyModule.first_foo #> [8, 4]

  # Certain module attributes have special behavior, and their names are reserved. 
  # Two of the most commonly-used reserved ones are @moduledoc and @doc:
defmodule Math do
  @moduledoc "Mathematical functions"

  @doc "Add two numbers together"
  def add(a, b), do: a + b

  @doc "Subtract one number from another number"
  def subtract(a, b), do: a - b
end

  # You can also use h to view a module or function’s documentation in IEx:
h Math #> Mathematical functions
…
h Math.add  #> def add(a, b)
            # >Add two numbers together
…
h Math.subtract #> def subtract(a, b)
                #> Subtract one number from another number
```

</details>

</details>

### 11. Elixir Structs  
<details><summary></summary>

#### Recap
<details><summary></summary>

- Structs are named maps with a defined list of keys.
- Define a struct with `defstruct` inside a module.
- Keys can have no default (i.e. default `nil`), a custom default, or can be
  made mandatory with `@enforce_keys`.
- Structs are fundamentally just maps, and all normal map functionality (like
  the `Map` module and the `%{ …| … }` syntax) works on them.
- A `%User{}` struct is represented internally as an Elixir map with the
  special key `__struct__` that has value `User`.

</details>

#### Code
<details><summary></summary>

```elixir
user = %{name: "Adam", email: "adam@example.com"} # Map doesn't enforce attrs and not named

  # Struct
defmodule User do; defstruct [:name, :email]; end
user = %User{name: "Adam", email: "adam@example.com"}
  # enforces keys
kurt = %User{name: "Kurt", email: "kurt@nirvana.com", age: 27} #> ** (KeyError) key :age not found
  # default to nil
%User{name: "Emily"}                                    #> %User{email: nil, name: "Emily"}

  # Can enforce with @enforce_keys
defmodule User do
  @enforce_keys [:name]
  defstruct [:name, :email]
end
%User{email: "hello@example.com"} #> ** (ArgumentError) the following keys must also be given when building struct User: [:name]

  # Or default value
defmodule Guitar do; defstruct [num_strings: 6]; end
%Guitar{} #=> %Guitar{num_strings: 6}

  # defstruct is a module, can incl fns
defmodule User do
  defstruct [:name, :email]

  def has_valid_email?(user), do: ...
end

  # Structs are maps
user = %User{name: "Adam", email: "adam@example.com"}
user.__struct__         #> User

  # with Map fns
user = %User{name: "Adam", email: "adam@example.com"}
Map.get(user, :name)
Map.put(user, :name, "Bill")
Map.keys(user)
Map.values(user)
Map.merge(user, %{name: "Dave"})
  # and can use %{ ... | ... | } syntax
user = %User{name: "Adam", email: "adam@example.com"}
%{user | email: "newaddress@example.com"}

  # Can pattern-match
%User{name: name} = %User{name: "Sarah", email: "stacey@company.com"}
name        #> "Sarah"

  # Can limit match on struct type
defmodule Person do; defstruct [:name]; end
defmodule Dog do; defstruct [:name]; end

%{name: name} = %Person{name: "Jess"};     name #> "Jess"
%Person{name: name} = %Person{name: "Ed"}; name #>  "Ed"
%Person{name: name} = %Dog{name: "Rover"} #> ** (MatchError) no match of right hand side value: %Dog{name: "Rover"}

  # This raises a FunctionClauseError if the first argument is not a Person:
def greet_person(%Person{} = person), do: IO.puts("Hello, #{person.name}!")
```

</details>

## 12. Date and time  

#### Recap
<details><summary></summary>

- Elixir provides `Date`, `Time`, and `NaiveDateTime` structs 
- which can be created with the sigils `~D`, `~T` and `~N` respectively. 
- There’s also `DateTime`, which doesn’t have a sigil.

</details>

#### Code
<details><summary></summary>

```elixir
date = ~D[1926-04-21] #> ~D[1926-04-21]
date.year             #> 1926
date.struct           #> Date

time = ~T[23:11:00] #> ~T[23:11:00]
time.hour           #> 23
time.__struct__     #> Time

  # NaiveDateTime doesn't include timezone
naive = ~N[1926-04-21 23:11:00] #> ~N[1926-04-21 23:11:00]
naive.hour           #> 23
naive.year           #> 1926
naive.__struct__     #> NaiveDateTime

dt = ~U[1926-04-21 23:11:00.00Z] #> ~U[1926-04-21 23:11:00.00Z]
dt.hour       #> 23
dt.year       #> 1926
dt.time_zone  #> "Etc/UTC"
dt.__struct__ #> DateTime

{:ok, dt} = DateTime.new(~D[1926-04-21], ~T[23:11:00], "Etc/UTC", Calendar.UTCOnlyTimeZoneDatabase)
              #> {:ok, ~U[1926-04-21 23:11:00Z]}
dt.time_zone  #> "Etc/UTC"
```

</details>

## 13. The pipe operator  

#### Code
<details><summary></summary>

```elixir
"MySubdomain.example.com.au    "
|> String.trim
|> String.downcase
|> String.split
  #> ["mysubdomain", "example", "com", "au"]

String.upcase("piping is fun") # sam as ...
"piping is fun" |> String.upcase

  # function call takes precedence over pipe operator
  #> Does it work like this?   fizz(2 |> buzz 3)
  # >Or like this?             fizz(2) |> buzz(3)
fizz 2 |> buzz 3
      #> warning: parentheses are required when piping into a function call. For example:
      #>     foo 1 |> bar 2 |> baz 3
      #> is ambiguous and should be written as
      #>     foo(1) |> bar(2) |> baz(3)
```

</details>

#### :bulb: For code analysis use [Credo](https://github.com/rrrene/credo)

</details>

</details>

# Part 2. A simple CRUD app
<details><summary></summary>

### 14. A simple Rails app  
<details><summary></summary>

</details>

#### rails new
<details><summary></summary>

```
rails new pensieve_rails
cd pensieve_rails
rails server
rails g scaffold memory title:string content:text
bin/rails db:migrate RAILS_ENV=development
```

</details>

### 15. Creating a new Phoenix app  
<details><summary></summary>

</details>

#### Recap
<details><summary></summary>

- `mix --version`
- `mix phx.new pensive` # [diff](https://github.com/arafatm/learn-phoenixonrails/commit/6a30419)
- `mix ecto.create`     # creates the DB
- `mix phx.server`      # To start the server
- `mix test`

</details>

#### <a href="https://medium.com/@a4word/continuous-testing-with-elixir-ddc1107c5cc0">Continuous Testing with Elixir. There is great power in having your… | by Andrew Forward | Medium</a>
<details><summary></summary>

- :ship: Upgrade mix_test_watch to 1.1 (latest) <a href='https://github.com/arafatm/learn-phoenixonrails/commit/9c3b262'>9c3b262</a>
- `mix deps.get` # [diff](https://github.com/arafatm/learn-phoenixonrails/commit/ae8e158)
- :ship: Clear terminal on each test run <a href='https://github.com/arafatm/learn-phoenixonrails/commit/77fc1be'>77fc1be</a>
- `mix test.watch`

```elixir
diff --git a/pensive/mix.exs
@@ -50,7 +50,7 @@ defmodule Pensive.MixProject do
       {:gettext, "~> 0.20"},
       {:jason, "~> 1.2"},
       {:plug_cowboy, "~> 2.5"},
-      {:mix_test_watch, "~> 0.3", only: :dev, runtime: false}
+      {:mix_test_watch, "~> 1.1", only: :dev, runtime: false}
     ]
   end
```
```elixir
diff --git a/pensive/config/config.exs
@@ -59,6 +59,10 @@ config :logger, :console,
 # Use Jason for JSON parsing in Phoenix
 config :phoenix, :json_library, Jason
+
+if Mix.env == :dev do
+  config :mix_test_watch, clear: true
+end
+
 # Import environment specific config. This must remain at the bottom
 # of this file so it overrides the configuration defined above.
 import_config "#{config_env()}.exs"
```

</details>

### 16. Directory structure and mix.exs  
<details><summary></summary>

</details>

#### Recap
<details><summary></summary>

- There’s no app directory in Phoenix; only lib, which is divided into two main subdirectories:
  - an “app directory” (lib/<app_name>) for your core business logic.
  - a “web directory” (lib/<app_name>_web) for the parts of your code that are specific to serving the app over the web.

|                     | Ruby (Bundler)                      | Elixir (Mix)                     |
| -                   | -                                   | -                                |
| Define deps in      | `Gemfile`                           | `deps` function within `mix.exs`
| Lockfile            | `Gemfile.lock`                      | `mix.lock`
| Environments        | `development`, `production`, `test` | `:dev`, `:prod`, `:test`
| Get the current env | `Rails.env`                         | `Mix.env`

</details>

#### Directory Structure
<details><summary></summary>

- `_build` is where `mix` puts your compiled code. Don’t edit this directory directly, and don’t check into source code.
- `deps` is where `mix` puts the source code for your app’s dependencies. Like `_build`, this shouldn’t be edited directly nor stored in source control.
- `lib` contains your source code - the equivalent of Rails’s `app`. You’ll spend most of your time in `lib` when developing a Phoenix app.
- `assets` is where you’ll put everything related to your front-end assets, like JavaScript and CSS files.
- `config` keeps - you guessed it - your app’s config.
- `priv` keeps (from the docs) “resources that are necessary in production but are not directly part of your source code”. This includes things like database migrations and translation files.
- `test` keeps your test files. Elixir tests use [ExUnit](https://hexdocs.pm/ex_unit/1.12/ExUnit.html) by default, while Rails apps are typically tested using [Minitest](https://github.com/minitest/minitest) or [RSpec](https://rspec.info/).

</details>

#### <a href="https://github.com/arafatm/learn-phoenixonrails/blob/main/pensive/mix.exs">mix.exs</a>
<details><summary></summary>

- contains basic configuration such as app name, versions
- defines app deps in `defp deps do`
- by default defines `:test`, `:dev`, `:prod`
  - e.g. `{:phoenix_live_reload, "~> 1.2", only: :dev},`
- Can also limit deps by runtime
  - e.g. `{:esbuild, "~> 0.5", runtime: Mix.env() == :dev},`
- `defp aliases` allows for cli aliases
  - e.g. `setup: ["deps.get", "ecto.setup"]` allows `mix setup` instead of `mix deps.get && mix ecto.setup`

</details>

#### The lib directory
<details><summary></summary>

- `lib/pensieve` contains the app’s core business logic, such as code that queries and updates the database.
- `lib/pensieve_web` handles only the things that are specifically related to serving the app over the web, such as routing HTTP requests and rendering HTML.

Separation of `_web` allows for distinction between _web only_ and general app logic

</details>

### 17. Routing and config  
<details><summary></summary>

</details>

#### Recap
<details><summary></summary>

|                     | **Phoenix**                             | **Rails**                          |
| ---                 | ---                                     | ---                                |
| Router file         | `lib/<app_name>_web/router.ex`          | `config/routes.rb`                 |
| Print routes at cli | `mix phx.routes`                        | `rails routes`                     |
| Define a GET route  | `get "/path", ThingController, :action` | `get "/path", to: "things#action"` |
| Other HTTP verbs    | `post`, `patch`, `delete`, etc.         | Same on both                       |
| General config      | `config/config.exs`                     | `config/application.rb`            |
| Env-specific config | `config/<env>.exs`                      | `config/environments/<env>.rb`     |

</details>

#### To create a simple _about_ page
<details><summary></summary>

- In Rails we need route, controller, view
- In Phx we need route, controller, _views and templates_

</details>

###### :ship: PensiveWeb.Router <a href='https://github.com/arafatm/learn-phoenixonrails/commit/9b98a18'>9b98a18</a>
<details><summary></summary>

```elixir
diff --git a/pensive/lib/pensive_web/router.ex
@@ -1,4 +1,5 @@
 defmodule PensiveWeb.Router do
+  # make routing functions available in this module
   use PensiveWeb, :router
 
   pipeline :browser do
@@ -14,9 +15,14 @@ defmodule PensiveWeb.Router do
     plug :accepts, ["json"]
   end
 
+  # 1st arg: all routes in this scope have paths starting with "/"
+  # 2nd arg: scope all controller in namespace `PensieveWeb`
+  #        - `PageController` == `PensieveWeb.PageController`
   scope "/", PensiveWeb do
+    # pipe_through: apply the `pipeline :browser` to all routes
     pipe_through :browser
 
+    # Default route when no path is given
     get "/", PageController, :home
   end
 
```

</details>

#### Print routes
<details><summary></summary>

```
mix phx.routes #=>
  GET  /                            PensieveWeb.PageController :home
  GET  /dev/dashboard               Phoenix.LiveDashboard.PageLive :home
  GET  /dev/dashboard/:page         Phoenix.LiveDashboard.PageLive :page
  GET  /dev/dashboard/:node/:page   Phoenix.LiveDashboard.PageLive :page
  *    /dev/mailbox                 Plug.Swoosh.MailboxPreview []
  WS   /live/websocket              Phoenix.LiveView.Socket
  GET  /live/longpoll               Phoenix.LiveView.Socket
  POST  /live/longpoll              Phoenix.LiveView.Socket
```
```
mix phx.routes --info / #=>
  Module: PensieveWeb.PageController
  Function: :home
  /path/to/your/repo/pensieve/lib/pensieve_web/controllers/page_controller.ex:4
```

</details>

###### :ship: Env specific configs <a href='https://github.com/arafatm/learn-phoenixonrails/commit/ba654c2'>ba654c2</a>
<details><summary></summary>

```elixir
diff --git a/pensive/config/dev.exs
@@ -1,3 +1,4 @@
+# `:dev` specific configs
 import Config
 
diff --git a/pensive/config/prod.exs
@@ -1,3 +1,4 @@
+# `:prod` specific configs
 import Config
 
diff --git a/pensive/config/test.exs
@@ -1,3 +1,4 @@
+# `:test` specific config
 import Config
 
diff --git a/pensive/lib/pensive_web/router.ex
@@ -31,6 +31,8 @@ defmodule PensiveWeb.Router do
   #   pipe_through :api
   # end
 
+  # Additional routes only for development and only if the `:dev_routes` env is set.
+  # access at localhost:4000/dev/dashboard
   # Enable LiveDashboard and Swoosh mailbox preview in development
   if Application.compile_env(:pensive, :dev_routes) do
     # If you want to use the LiveDashboard in production, you should put
```
`live_dashboard` can be access in dev at http://localhost:4000/dev/dashboard

</details>

###### :ship: route /about <a href='https://github.com/arafatm/learn-phoenixonrails/commit/39bf15c'>39bf15c</a>
<details><summary></summary>

```elixir
diff --git a/pensive/lib/pensive_web/router.ex
@@ -24,6 +24,7 @@ defmodule PensiveWeb.Router do
 
     # Default route when no path is given
     get "/", PageController, :home
+    get "/about", PageController, :about
   end
 
   # Other scopes may use custom stacks.
```

</details>

### 18. Controllers and templates  
<details><summary></summary>

</details>

#### Recap
<details><summary></summary>

|                | Phoenix                                                      | Rails                                           |
| --             | --                                                           | --                                              |
| ctrlr define   | `use PensieveWeb, :controller`                               | `< ApplicationController`
| ctrlr live in  | `lib/pensieve_web/controllers`                               | `app/controllers`
| ctrlr naming   | singular e.g. `PagesController`                              | pluralized e.g. `PagesController`
| ctrlr actions  | `%Plug.Conn{}` + params struct; must return a `%Plug.Conn{}` | take no args; can return anything
| ctrlr `params` | must be passed in as second arg to action (even if unused)   | available by magic
| HTML templates | “templates” in e.g. `lib/pensieve_web/controllers/page_html` | “views” in e.g. `app/views/pages`
| rendering      | call `render `explicitly, e.g. `render(conn, :index)`        | render view with same name as action by default

</details>

#### Plug.Conn
<details><summary></summary>

A `%Plug.Conn{}` represents an HTTP request and response
- actions _must_ return a `%Plug.Conn{}`
- can also `render` or return a `404`

xxx

</details>

### 19. Tailwind  
<details><summary></summary>

</details>

### 20. Embedded Elixir  
<details><summary></summary>

</details>

### 21. Layouts  
<details><summary></summary>

</details>

### 22. Phoenix views  
<details><summary></summary>

</details>

### 23. Ecto.Migration  
<details><summary></summary>

</details>

### 24. Ecto.Schema  
<details><summary></summary>

</details>

### 25. Ecto.Repo  
<details><summary></summary>

</details>

### 26. Route helpers  
<details><summary></summary>

</details>

### 27. Index page  
<details><summary></summary>

</details>

### 28. Function components  
<details><summary></summary>

</details>

### 29. Core components  
<details><summary></summary>

</details>

### 30. Phoenix contexts  
<details><summary></summary>

</details>

### 31. Helper functions  
<details><summary></summary>

</details>

### 32. Ecto.Changeset  
<details><summary></summary>

</details>

### 33. New and Create  
<details><summary></summary>

</details>

### 34. Errors and I18n  
<details><summary></summary>

</details>

### 35. Edit and Update  
<details><summary></summary>

</details>

### 36. Deleting memories  
<details><summary></summary>

</details>

### 37. Recap  
<details><summary></summary>

</details>

#### Recap
<details><summary></summary>

Way back at the beginning, we scaffolded a simple Rails app with this command:

`rails g scaffold memory title:string content:text`

This generated a simple app providing the basic CRUD (create, read, update,
destroy) operations on a `Memory` model, using the seven basic RESTful routes:
`index`, `show`, `new`, `create`, `edit`, `update`, `destroy`.

We’ve now recreated all of this functionality in Phoenix. Along the way, we’ve
been introduced to most of the core Phoenix concepts, and seen how they compare
to Rails:
- The Phoenix **router** works just like a Rails router: 
  - it takes an incoming HTTP request and decides which controller action to route it to.
- Phoenix **controllers** take a request and are responsible for rendering a response.
  - They’re very conceptually similar to Rails controllers.
- Where Rails uses **views** to generate HTML response bodies 
  - (or other types of output e.g. JSON), 
  - Phoenix has both **views** and **templates**.
  - Templates are convenience files that are compiled as functions within the views.
- Rails **helpers** are modules containing helper code for the view layer.
  - Phoenix doesn’t have dedicated “helper” modules like this, 
  - but you can define helper functions directly within your view modules.
- Rails’s default rendering engine is **ERb**, embedded Ruby.
  - Phoenix uses **HEEx**, “HTML + Embedded Elixir”.
  - ERb and HEEx use similar syntax, outputting code between `<%=` and `%>` tags.
- Rails uses **ActiveRecord** models for data persistence, querying and validation.
  - In Phoenix these responsibilities are divided within different parts of the **Ecto** library, 
  - including `Ecto.Schema`, `Ecto.Query` (which we haven’t looked at yet), 
  - `Ecto.Changeset` and `Ecto.Validation`.
- Rails models also serve as a catch-all place to put your business logic.
  - In Phoenix, business logic is organised into simple Elixir modules called **contexts**.
- Rails and Phoenix both use **migrations** to make changes to your database schema: 
  - `ActiveRecord::Migration` in Rails and `Ecto.Migration` in Phoenix.

</details>

## Part 3. Advanced concepts

### 38. Dependency management  
<details><summary></summary>

</details>

### 39. Erlang libraries  
<details><summary></summary>

</details>

### 40. use  
<details><summary></summary>

</details>

### 41. Plug and pipelines  
<details><summary></summary>

</details>

### 42. Scaffolding  
<details><summary></summary>

</details>

### 43. with  
<details><summary></summary>

</details>

### 44. Ecto.Query  
<details><summary></summary>

</details>

### 45. LiveView  
<details><summary></summary>

</details>

## Part 4. Twittex

### 46. phx.gen.auth  
<details><summary></summary>

</details>

### 47. Database indexes  
<details><summary></summary>

</details>

### 48. The User schema  
<details><summary></summary>

</details>

### 49. Uniqueness validations  
<details><summary></summary>

</details>

### 50. User registration  
<details><summary></summary>

</details>

### 51. User sessions  
<details><summary></summary>

</details>

### 52. Auth routes and plugs  
<details><summary></summary>

</details>

### 53. Static files  
<details><summary></summary>

</details>

### 54. Assets and esbuild  
<details><summary></summary>

</details>

### 55. Phoenix.Param  
<details><summary></summary>

</details>

### 56. Associations  
<details><summary></summary>

</details>

### 57. Preloads  
<details><summary></summary>

</details>

### 58. Emails and password resets  
<details><summary></summary>

</details>

### 59. LiveView sessions  
<details><summary></summary>

</details>

### 60. LiveView forms  
<details><summary></summary>

</details>

### 61. File uploads  
<details><summary></summary>

</details>

### 62. Follows  
<details><summary></summary>

</details>

### Conclusion
<details><summary></summary>
</details>
