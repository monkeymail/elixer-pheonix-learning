defmodule PasswordGeneratorTest do
  use ExUnit.Case

  setup do
    # variables we need throughout our tests
    # Map of options used in the password generator
    # Args used in password generator generate function
    options = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "false",
      "symbols" => "false"
    }

    options_type = %{
      # Get a collection with all lowercase letters
      lowercase: Enum.map(?a..?z, & <<&1>>),
      numbers: Enum.map(0..9, & Integer.to_string(&1)),
      uppercase: Enum.map(?A..?Z, & <<&1>>),
      # trim: true to remove any whitespace insude the list.
      symbols: String.split("!#$%&()*+,-./:;<=>?@[]^_{|}~", "", trim: true)
    }

    # Pattern match the function to generate a password.
    {:ok, result} = PasswordGenerator.generate(options)

    %{
      options_type: options_type,
      result: result
    }
  end

  # Let's write some tests
  # Test if the result we get back is a string or not.
  test "returns a string", %{result: result} do
    assert is_bitstring(result)
  end

  # If we pass an option or a map with no length, we should return an error.
  test "returns error when no length is given" do
    options = %{"invalid" => "false"}

    # Return an error and discard the result
    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  # The length option should always be an integer.
  test "returns error when length is not an integer" do
    options = %{"length" => "ab"}

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  # Test the length of the string returned matches the length option.
  test "length of returned string is the option provided" do
    length_option = %{"length" => "5"}
    {:ok, result} = PasswordGenerator.generate(length_option)

    assert 5 = String.length(result)
  end

  # Assert that we get a result back if we pass in just a length.
  test "returns a lowercase string just with the length", %{options_type: options} do
    length_option = %{"length" => "5"}
    {:ok, result} = PasswordGenerator.generate(length_option)

    # Check the password contains lowercase letters.
    assert String.contains?(result, options.lowercase)

    # Check it doesn't contain any of the below.
    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.uppercase)
    refute String.contains?(result, options.symbols)
  end

  # All the values from the bottom three options should be booleans.
  test "returns error when options values are not booleans" do
    options = %{
      "length" => "10",
      "numbers" => "invalid",
      "uppercase" => "0",
      "symbols" => "false"
    }

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "returns error when options not allowed" do
    options = %{
      "length" => "5",
      "invalid" => "true"
    }

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "returns error when 1 option not allowed" do
    options = %{
      "length" => "5",
      "numbers" => "true",
      "invalid" => "true"
    }

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "returns string uppercase", %{options_type: options} do
    options_with_uppercase = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "true",
      "symbols" => "false"
    }

    {:ok, result} = PasswordGenerator.generate(options_with_uppercase)

    assert String.contains?(result, options.uppercase)

    # Check it doesn't contain any of the below.
    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.symbols)
  end

  test "returns string just with numbers", %{options_type: options} do
    options_with_numbers = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "false",
      "symbols" => "false"
    }

    {:ok, result} = PasswordGenerator.generate(options_with_numbers)

    assert String.contains?(result, options.numbers)

    # Check it doesn't contain any of the below.
    refute String.contains?(result, options.uppercase)
    refute String.contains?(result, options.symbols)
  end

  test "returns string with uppercase and numbers", %{options_type: options} do
    options_included = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "true",
      "symbols" => "false"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options.uppercase)
    assert String.contains?(result, options.numbers)

    # Check it doesn't contain any of the below.
    refute String.contains?(result, options.symbols)
  end

  # Now let's test for symbols.
  test "returns string with symbols", %{options_type: options} do
    options_included = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "false",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options.symbols)

    # Check it doesn't contain any of the below.
    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.uppercase)
  end

  test "returns string with all included options", %{options_type: options} do
    options_included = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "true",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options.symbols)
    assert String.contains?(result, options.uppercase)
    assert String.contains?(result, options.numbers)
  end

  test "returns string with symbols and uppercase", %{options_type: options} do
    options_included = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "true",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options.symbols)
    assert String.contains?(result, options.uppercase)

    # Check it doesn't contain any of the below.
    refute String.contains?(result, options.numbers)
  end

  test "returns string with symbols and numbers", %{options_type: options} do
    options_included = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "false",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options.symbols)
    assert String.contains?(result, options.numbers)

    # Check it doesn't contain any of the below.
    refute String.contains?(result, options.uppercase)
  end
end
