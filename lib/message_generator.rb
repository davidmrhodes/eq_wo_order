require 'colorizer'

class EqJsonMessageGenerator

  def initialize(matcher)
    @matcher = matcher
    @colorizer = EqJsonColorizer.new
  end

  def generateTypeMissMatchFailureMessage()

    if @matcher.currentJsonKey.nil?
      actualType = getJsonType(@matcher.actual)
      expectedType = getJsonType(@matcher.expected)
    else
      actualType = getJsonType(@matcher.currentActualObj)
      expectedType = getJsonType(@matcher.currentExpectedObj)
      currentJsonDiff = "\tExpected: #{@matcher.currentExpectedObj.to_json}\n" +
          @colorizer.green("\t  Actual: #{@matcher.currentActualObj.to_json}") + "\n"
    end

    jsonErrorInfo = "JSON path #{@matcher.jsonPath} expected #{expectedType} type but actual is #{actualType}\n"
    unless currentJsonDiff.nil?
      jsonErrorInfo << currentJsonDiff
    end

    return getExpectedActualJson() +"\n" +
        "Diff:\n" +
        "#{jsonErrorInfo}"
  end

  def generateDifferentValueMessage()

    # TODO have item in todo list to use a diff if the value is a String
    #      with mutiple lines so leaving this diff code even though it is not
    #      being used
    differ = RSpec::Support::Differ.new

    differ = RSpec::Support::Differ.new(
        :object_preparer => lambda {|expected| RSpec::Matchers::Composable.surface_descriptions_in(expected)},
        :color => RSpec::Matchers.configuration.color?
    )

    @difference = differ.diff_as_object(@matcher.currentExpectedObj, @matcher.currentActualObj)
    # End unused code

    return getExpectedActualJson() + "\n" +
        "Diff:\n" +
        "JSON path #{@matcher.jsonPath}\n" +
        "\texpected: \"#{@matcher.currentExpectedObj}\"\n" +
        @colorizer.green("\t     got: \"#{@matcher.currentActualObj}\"")
  end

  def generateDifferentKeyMessage()
    if @matcher.currentActualObj.nil?
      objectsNotInExpected = getObjectsNotIn(@matcher.actual, @matcher.expected);
      objectsNotInActual = getObjectsNotIn(@matcher.expected, @matcher.actual);
    else
      objectsNotInExpected = getObjectsNotIn(@matcher.currentActualObj, @matcher.currentExpectedObj);
      objectsNotInActual = getObjectsNotIn(@matcher.currentExpectedObj, @matcher.currentActualObj);
    end

    jsonErrorInfo = "JSON path #{@matcher.jsonPath}\n"

    unless objectsNotInExpected.empty?
      jsonErrorInfo << "expected does not contain #{objectsNotInExpected.to_json}\n"
    end

    unless objectsNotInActual.empty?
      jsonErrorInfo << @colorizer.green("actual does not contain #{objectsNotInActual.to_json}\n")
    end

    differ = RSpec::Support::Differ.new

    differ = RSpec::Support::Differ.new(
        :object_preparer => lambda {|expected| RSpec::Matchers::Composable.surface_descriptions_in(expected)},
        :color => RSpec::Matchers.configuration.color?
    )

    if @matcher.currentActualObj.nil?
      @difference = differ.diff(@matcher.expected, @matcher.actual)
    else
      @difference = differ.diff(@matcher.currentExpectedObj, @matcher.currentActualObj)
    end

    return getExpectedActualJson() + "\n" +
        "\nDiff:\n" +
        jsonErrorInfo +
        @difference
  end

  def getExpectedActualJson
    expectedJson=@matcher.expected.to_json;
    actualJson=@matcher.actual.to_json;

    return "Expected: #{expectedJson}\n" +
        @colorizer.green("  Actual: #{actualJson}")
  end

  def getObjectsNotIn(hash1, hash2)
    missing = {}
    hash1.each do |hash1_key, hash1_value|
      unless hash2.has_key?(hash1_key)
        missing[hash1_key] = hash1_value
      end
    end
    return missing
  end

  def getJsonType(rubyJsonObject)
    case rubyJsonObject
      when Array
        return "array"
      when Hash
        return "object"
      else
        return "not json"
    end
  end

  def generateDifferentSizeArrayMessage()
    if @matcher.currentActualObj.nil?
      expectedLength = @matcher.expected.length
      actualLength = @matcher.actual.length
    else
      expectedLength = @matcher.currentExpectedObj.length
      actualLength = @matcher.currentActualObj.length
    end

    jsonErrorInfo = "JSON path #{@matcher.jsonPath}[] expected length #{expectedLength} " +
        "actual length #{actualLength}\n"

    return getExpectedActualJson() + "\n" +
        "\nDiff:\n" +
        jsonErrorInfo
  end

  def generateExpectedItemNotFoundInArray(expected_item, expected_count, actual_count)
    # if @matcher.currentActualObj.nil?
    #    objectsNotInExpected = getObjectsNotInArray(@matcher.actual, @matcher.expected);
    #    objectsNotInActual = getObjectsNotInArray(@matcher.expected, @matcher.actual);
    # else
    #    objectsNotInExpected = getObjectsNotIn(@matcher.currentActualObj, @matcher.currentExpectedObj);
    #    objectsNotInActual = getObjectsNotIn(@matcher.currentExpectedObj, @matcher.currentActualObj);
    # end

    if actual_count == 0
      jsonErrorInfo = "JSON path #{@matcher.jsonPath}[] could not find:\n" +
          "#{expected_item.to_json}\n" +
          "in actual\n"
    else
      jsonErrorInfo = "JSON path #{@matcher.jsonPath}[] wrong number of:\n" +
          "#{expected_item.to_json}\n" +
          "in actual\n" +
          "expected: #{expected_count}\n" +
          @colorizer.green("     got: #{actual_count}") + "\n"
    end

    # unless objectsNotInExpected.empty?
    #   jsonErrorInfo << "expected does not contain #{objectsNotInExpected.to_json}\n"
    # end
    #
    # unless objectsNotInActual.empty?
    #   jsonErrorInfo << @colorizer.green("actual does not contain #{objectsNotInActual.to_json}\n")
    # end

    return getExpectedActualJson() + "\n" +
        "\nDiff:\n" +
        jsonErrorInfo
  end

end
