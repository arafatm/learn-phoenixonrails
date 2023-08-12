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

Elixir _doesn't have classes_, but it has __modules__

###### Functional vs. Object-Oriented

```elixir
String.upcase(name) # vs Ruby: name.upcase
```
###### Immutability vs Mutability

In Elixir, everything behaves like a Ruby symbol. There’s no equivalent of
`capitalize!` on a Elixir string because Elixir __can’t mutate the string__ in
place.

###### Compiled vs Interpreted

Elixir files end in `.ex`, and get compiled to BEAM files with extension `.beam`.

<details><summary>Compiling `elixirc` vs `elixir` </summary>

```bash
elixirc math.ex # creates Elixir.Math.Bem

elixir math.exs # Doesn't save .beam
```
</details>

###### Recap

|                | Ruby                                                               | Elixir                                      |
| ---            | ---                                                                | ---                                         |
| paradigm       | Object-oriented                                                    | Functional                                  |
| Console        | `irb` (Press `Ctrl + D` to exit)                                   | `iex` (Press `Ctrl + C` twice to exit)      |
| Mutability     | Some objects (strings) are mutable, others (symbols) are immutable | Everything is immutable                     |
| File extension | `.rb`                                                              | `.ex` or `.exs`                             |
| Execution      | Interpreted                                                        | Compile `.ex` files, interpret `.exs` files |

### 3. Basic Elixir syntax  

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

[Comprehensions - The Elixir programming language](https://elixir-lang.org/getting-started/comprehensions.html)
- sytactic sugar for looping over enumerables
- have 3 parts: generators, filters, and collectables

### 4. Elixir modules  

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

#### Recap

Module

|                            | **Ruby**                                     | **Elixir**                                                   |
| ---                        | ---                                          | ---                                                          |
| create a module            | `module`                                     | `defmodule`                                                  |
| using a module’s functions | mix in to a class with `include` or `extend` | call directly e.g. `Math.add(2, 2)`, or import with `import` |
| private functions          | `private`                                    | `defp`                                                       |
| protected functions        | `protected`                                  | don’t exist                                                  |

Alias

| **Syntax**                  | **Result**                                                       |
| ---                         | ---                                                              |
| `alias Foo.Bar, as: Bar`    | adds `Bar` as alternative name for `Foo`                         |
| `alias Foo.Bar`             | shorthand for `alias Foo.Bar, as: Bar`                           |
| `alias Foo.{Bar, Car, Dar}` | shorthand for `alias Foo.Bar`, `alias Foo.Car`, `alias Foo.Dar`. |

### 5. Atoms, Lists and Tuples  

xxx

### 6. Sigils  
### 7. Pattern matching  
### 8. Elixir Maps  
### 9. Keyword Lists  
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
