---
source: https://phoenixonrails.com
title: Phoenix on Rails
---

[Phoenix on Rails](https://phoenixonrails.com)

## 1. Intro  

Using [asdf-vm/asdf-elixir: Elixir plugin for asdf version manager](https://github.com/asdf-vm/asdf-elixir)

:dog: 

<details><summary>:ship: Install Elixir/Erlang w/ asdf</summary>

- `asdf install elixir 1.15.4-otp-25`
- `asdf install erlang 25.3.2.5       # VSCode elixirLS does not support OTP 26`
- `mix local.hex`
- `mix archive.install hex phx_new`
- `mix phx.new --version` #> Phoenix installer v1.7.7
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

xxx

### 4. Elixir modules  

###### Variables

### 5. Atoms, Lists and Tuples  
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
