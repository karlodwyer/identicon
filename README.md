# Identicon

This module is based on one of the projects from [Stephen Grider's](https://github.com/StephenGrider) awesome Udemy course 
"[The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/learn/v4/overview)", I've stayed faithful to the idea, but I made a few small changes.
I've added tests, a little documentation and made a little command line app that uses the `identicon` code.

## Running from the command line

Build an executable app:
```
mix escript.build
```

And then enjoy:
```
./identicon "Your Name"
```

Also if you need some help:
```
./identicon --help
```

## Installation

I wouldn't recommend using this package in any serious project but it can be installed
by adding `identicon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:identicon, github: "karlodwyer/identicon"}
  ]
end
```

## Miscellaneous 

Build the beautiful elixir docs:
```
mix docs
```

Run the tests (both unit and doc tests)
```
mix tests
```
