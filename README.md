# elixer-pheonix-learning
This is a repo to help me learn and begin developing in the Elixer language and Pheonix framework.

Elixer is based on Motorola's battle tested languages. It is concurrent, functional and fault tolerant languages.

Pheonix is a framework built on top of Elixer.

Using this tutorial: https://www.youtube.com/watch?v=gRQIPvDFuts

## Basics Elixir
= does not set variables like in other languages, it matches. You can use the pin ^ operator to prevent LHS binding on equals operator.

You can discard values with _

Tuples are assigned with {}

if do else unless end does conditionals. 

colour = "blue"
if colour == "blue", do: "yes"

unless colour == "blue" do
    "yes"
end

if colour == "red" do
    "yes"
else
    "no"
end

unless colour == "blue", do "no", else "yes"

You can use short or long form as shown in examples above.

### Case statements
we can use case statements

result = {:ok, "success"}

case result do
    {:ok, result} -> "this matches"
    {:error, error} -> "this won't match"
    - -> "Matches anything else"
end

Wew can suppress the unused variable warnings above by discarding the variables.

result = {:ok, "success"}

case result do
    {:ok, _result} -> "this matches"
    {:error, _error} -> "this won't match"
    - -> "Matches anything else"
end

### Cond - match against conditions

colour = "blue"

cond do 
    colour == "blue" -> colour
    colour == "red" -> colour
    true -> "this catches everything else, result: #{colour}"
end

### With Condition

useful when we need more than one match for the code to be executed.

result = {:ok, "result"}
error = {:error, "error"}

with {:ok, result} <- result do
    result
end

More common use case when there are two comparisons

with {:ok, _result} <- result,
        {:error, _result} <- error do
    "This gets executed"
end

you can also have an else statement

result = {:ok, "resultt"}

with {:ok, "result} <- result do
    result
else
    {:ok, _result} -> "This gets executed"
end

The above evaluates to the else.

### Anonymous Functions
We can use anonymouse functions when we want to group a block of code so we can analyse data.
```
sum = fn a, b -> a + c end

sum.(2, 3)
>> 5
```
The shorthand version:
```
sum = &(&1 + &2)
sum.(2,3)

say_hello = fn name -> "Hello #{name}" end
say_hello.("John")
>> "Hello John"

say_hello = &("Hello #{&1}")
say_hello.("John")
>> "Hello John"
```
can do pattern matches in these functions
```
handle_result = fn
    {:ok, result} -> result
    {:error, error} -> error
end

handle_result.({:ok, "success"})
>> "success"
handle_result.({:error, "error"})
>> "error"
```

### Modules
Modules are used to organise named and private functions into a namespace.

def module name must start with a capital letter. Eg Math below.

```
defmodule Math do
    def sum(num1, num2) do
        num1 + num2
    end
end

Math.sum(1,2)
>>> 3
```

You can also have private functions in these modules with defp. As expected, private functions can only be accessed inside the module. But called be called outside.
```
defModule Greet do
    def hello(name) do
        greeting(name)
    end

    defp greeting(name) do
        "Hello" <> " " <> name
    end
end

Greet.hello("John")
>>> "Hello John"

Greet.greeting("John")
>>> UndefinedFunctionError...

```
You can use dots in module names. Eg defmodule Greeting.Example do ...

### Module Attributes
constants throughout the module.

```
defmodule Greetings do
    @name "George"

    def hello(), do: "Hello #{@name}"
    def morning(), do: "Good Morning #{@name}"
end

```

### Docstrings and Comments

```
defmodule Example do
    @moduledoc"""
    this is a module doc
    """

    @doc"""
    This is a test function module doc
    """
    def test() do
        "this is a test"
    end

    # This is a comment
    def test2(), do: "nothing" # This is an inline commend
end
```

### Structs
Special maps with a defined set of keys and default values. A struct must be defined within a module, which it takes its name from. It is common for a struct to be the only thin defined within a module.

To define a struct we use defstruct along with a keyword list of fields and default values.

```
defmodule User do
    defstruct [:name, :age] # default values are nil.
end

u = %User{age: 20}
U.age
>>> 20
u.name
>>> nil
```

You can also do pattern match with structs.

```
%User{age: age} = u
age
>>> 20
```

### Alias
Used to alias module names when we need to use them within other modules.

Essentially useful for aliasing a long name as a short name in another module.

```
defmodule Display.Result do
    def math(result) do
        "Your result is #{result}"
    end
end

defmodule Math do
    alias Display.Result # Aliased as Display

    def sum(num1, num2) do
        num1 + num2
    end

    def display_result() do
        result = sum(1,2)
        Result.math(result)
    end

    def display do
        result = sum(1, 2)
        Display.Result.math(result)
    end
end
```

Can also specify an alias

```
defmodule Math do
    alias Display.Result, as: Show

    def sum(num1, num2) do
        num1, num2
    end

    def display do
        result = sum(1,2)
        Show.math(result)
    end
end
```

You can also alias multiple modules in one line.

```
defmodule Display.Result do
    def math(result) do
        "Your result is #{result}"
    end
end
defmodule Display.Math do
    def add(a,b) do
        "Your result is #{a + b}"
    end
end

def module MyModule do
    alias Display.{Result, Math}

    def add(a, b) do
        Math.add(a,b)
    end

    def display_math(result) do
        Result.math(result)
    end
end

MyModule.add(2,4)
>>> "Your result is 6"
```

### Imports
Can we used to import functiosn from other modules to call them without using module name. Just call the function name

```
defmodule ImportExample do
    import Math

    def import_sum(num1, num2) do
        sum(num1, num2)
    end
end

ImportExample.import_sum(1,2)
>>> 3

# The other function from the imported module won't appear
ImportExample.display()
>>> UndefinedFunctionError...

# Only import a specific function
defmodule ImportExample do
    import Math, only: [sum: 2] # The 2 here is to specify the two args needed for that function.

    def import_sum(num1, num2) do
        sum(num1, num2)
    end
end

ImportExample.import_sum(1,2)
>>> 3

# We can also exclude specific functions
defmodule ImportExample do
    import Math, except: [sum: 2]
end

ImportExample.sum(1, 2)
>>> warning: unused import Math
>>> UndefinedFunctionError...
```

## Functions
### Function Arguements
As we saw in the last example, the number of args in a function can be specified during an import. Why is this?

Well in Elixir you can have the same function with different definitions based on the number of args passed into the function.

```
defmodule Say do
    def hello(), do: "Hello!"

    def hello(name), do: hello() <> " " <> name

    def hello(name, last_name) do
        "Hello #{name} #{last_name}!"
    end

    def hello(greeting, name, last_name) do
        "#{greeting}! #{name} #{last_name}"
    end
end

Say.hello()
>>> "Hello!"
Say.hello("John")
>>> "Hello! John"

# default values for args in functions
defmodule Say do
    def hello(name, last_name, greeting \\ "Hello!") do
        "#{greeting}!! #{name} #{last_name}"
    end
end

Say.hello("John", "Barton")
>>> "Hello!! John Barton
```

### Function Pattern Matching
```
defmodule Alphabet do
    def letter(:a), do: "a"
    def letter(:b), do: "b"
    def letter(letter), do letter # Default on any value.
end

Alphabet.letter("letter")
```
### Function Conditions
You can do essentially the same thing with conditions as above with pattern matching. 

```
defmodule Alphabet do
    def letter(letter) when letter == :a do
        "a"
    end
    def letter(letter) when letter == :b do
        "b"
    end
    def letter(letter), do: letter
end
```

## Useful modules
There's lots of useful modules. Eg Integer and String
eg String.capitalize("john")

Or Map module with Map.put(some_map, "a_key", "a_value")

### Kernel module
These are built in. Eg length(l) or trunc 1.23

## Pipe Operator
Passes the result of an expression as the first parameter of another expression. Similar to R or bash.

```
string = " My String "

string
|> String.downcase()
|> String.trim()
|> String.split()
|> Enum.join("-")
>>> "my-string"
```

# Install Elixir

Mixture of this guide:
https://apollin.com/how-to-install-elixir-on-ubuntu-22-using-asdf/ 

and:
https://asdf-vm.com/guide/getting-started.html

Using asdf version manager. Allows for local and global version setting.

For Ubuntu 23.04 some package names have changed (specifically libwxgtk-webview3.2-dev libwxgtk-webview3.2-dev). use:
sudo apt-get -y install build-essential autoconf m4 libncurses5-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk libwxgtk-webview3.2-dev libwxgtk-webview3.2-dev  # erlang dependencies

