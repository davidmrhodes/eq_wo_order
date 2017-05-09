require 'json'
require 'eq_json_array_with_key'
require 'spec_helper.rb'

describe 'test item miss match' do

  it 'actual does not contain an expected item' do

    actual = {
        bookSeller: "amazon",
        bookWholeSellers: {
            publisherInfo: {
                name: "ACME Publisher Inc.",
                publishDate: {
                    month: 3,
                    day: 23,
                    year: 2015
                },
                products: {
                    books: [
                        {
                            bookId: "1",
                            name: "Harry Potter and the Sorcerer's Stone",
                            author: "J.K. Rowling"
                        },
                        {
                            bookId: "2",
                            name: "Eragon",
                            author: "Christopher Paolini",
                        },
                        {
                            bookdId: "4",
                            name: "Effective Java",
                            authoer: "Cannot Remember"
                        }
                    ]
                }
            }
        },
        url: "www.amazon.com"

    }
    actualArray = actual[:bookWholeSellers][:publisherInfo][:products][:books]

    expected = {
        bookSeller: "amazon",
        bookWholeSellers: {
            publisherInfo: {
                name: "ACME Publisher Inc.",
                publishDate: {
                    month: 3,
                    day: 23,
                    year: 2015
                },
                products: {
                    books: [
                        {
                            bookId: "3",
                            name: "The Fellowship of the Ring",
                            author: "J.R.R. Tolkien"

                        },
                        {
                            bookId: "1",
                            name: "Harry Potter and the Sorcerer's Stone",
                            author: "J.K. Rowling"
                        },
                        {
                            bookId: "2",
                            name: "Eragon",
                            author: "Christopher Paolini"
                        }
                    ]
                }
            }
        },
        url: "www.amazon.com"
    }

    expectedArray = expected[:bookWholeSellers][:publisherInfo][:products][:books]


    customMatcher=EqualJsonArrayWithKey.new(expectedArray, :bookId)

    expect(customMatcher.matches?(actualArray)).to eq(false)

    expectedJson=expected.to_json;
    actualJson=actual.to_json;

    String expectedErrorMessage= "bookId 3 not found in actual\n" +
        "Expected: {\"bookId\":\"3\",\"name\":\"The Fellowship of the Ring\",\"author\":\"J.R.R. Tolkien\"}\n";

    expect(customMatcher.failure_message).to eq(expectedErrorMessage)

    expect(actualArray).not_to eq_json_array_with_key(expectedArray, :bookId)

  end

  # TODO add test for key not in expected.  Strange case really user error

  # TODO write test case if key is not a symbol.

  # TODO write test case when arrays are not the same size.  Can list expected not in actual and actual not in expected
  it 'actual contains more items than expected' do

    actual = {
        bookSeller: "amazon",
        bookWholeSellers: {
            publisherInfo: {
                name: "ACME Publisher Inc.",
                publishDate: {
                    month: 3,
                    day: 23,
                    year: 2015
                },
                products: {
                    books: [
                        {
                            bookId: "1",
                            name: "Harry Potter and the Sorcerer's Stone",
                            author: "J.K. Rowling"
                        },
                        {
                            bookId: "2",
                            name: "Eragon",
                            author: "Christopher Paolini",
                        },
                        {
                            bookId: "4",
                            name: "Effective Java",
                            authoer: "Cannot Remember"
                        },
                        {
                            bookId: "5",
                            name: "The HP Way",
                            authoer: "Bill and Dave"
                        },
                        {
                            bookId: "3",
                            name: "The Fellowship of the Ring",
                            author: "J.R.R. Tolkien"

                        }
                    ]
                }
            }
        },
        url: "www.amazon.com"

    }
    actualArray = actual[:bookWholeSellers][:publisherInfo][:products][:books]

    expected = {
        bookSeller: "amazon",
        bookWholeSellers: {
            publisherInfo: {
                name: "ACME Publisher Inc.",
                publishDate: {
                    month: 3,
                    day: 23,
                    year: 2015
                },
                products: {
                    books: [
                        {
                            bookId: "3",
                            name: "The Fellowship of the Ring",
                            author: "J.R.R. Tolkien"

                        },
                        {
                            bookId: "1",
                            name: "Harry Potter and the Sorcerer's Stone",
                            author: "J.K. Rowling"
                        },
                        {
                            bookId: "2",
                            name: "Eragon",
                            author: "Christopher Paolini"
                        }
                    ]
                }
            }
        },
        url: "www.amazon.com"
    }

    expectedArray = expected[:bookWholeSellers][:publisherInfo][:products][:books]


    customMatcher=EqualJsonArrayWithKey.new(expectedArray, :bookId)

    expect(customMatcher.matches?(actualArray)).to eq(false)

    expectedJson=expected.to_json;
    actualJson=actual.to_json;

    String expectedErrorMessage= "Array size does not match. Expected 3 actual 5\n" +
        "expected does not contain bookIds [\"4\", \"5\"]\n"

    expect(customMatcher.failure_message).to eq(expectedErrorMessage)

    expect(actualArray).not_to eq_json_array_with_key(expectedArray, :bookId)

  end

  it 'actual item has more keys than expected' do

    actual = {
        bookSeller: "amazon",
        bookWholeSellers: {
            publisherInfo: {
                name: "ACME Publisher Inc.",
                publishDate: {
                    month: 3,
                    day: 23,
                    year: 2015
                },
                products: {
                    books: [
                        {
                            bookId: "1",
                            name: "Harry Potter and the Sorcerer's Stone",
                            author: "J.K. Rowling"
                        },
                        {
                            bookId: "2",
                            name: "Eragon",
                            author: "Christopher Paolini",
                            isbn: 1234
                        },
                        {
                            bookId: "3",
                            name: "The Fellowship of the Ring",
                            author: "J.R.R. Tolkien"
                        }
                    ]
                }
            }
        },
        url: "www.amazon.com"

    }
    actualArray = actual[:bookWholeSellers][:publisherInfo][:products][:books]

    expected = {
        bookSeller: "amazon",
        bookWholeSellers: {
            publisherInfo: {
                name: "ACME Publisher Inc.",
                publishDate: {
                    month: 3,
                    day: 23,
                    year: 2015
                },
                products: {
                    books: [
                        {
                            bookId: "1",
                            name: "Harry Potter and the Sorcerer's Stone",
                            author: "J.K. Rowling"
                        },
                        {
                            bookId: "2",
                            name: "Eragon",
                            author: "Christopher Paolini"
                        },
                        {
                            bookId: "3",
                            name: "The Fellowship of the Ring",
                            author: "J.R.R. Tolkien"

                        }
                    ]
                }
            }
        },
        url: "www.amazon.com"
    }

    expectedArray = expected[:bookWholeSellers][:publisherInfo][:products][:books]


    customMatcher=EqualJsonArrayWithKey.new(expectedArray, :bookId)

    expect(customMatcher.matches?(actualArray)).to eq(false)

    expectedJson=expected.to_json;
    actualJson=actual.to_json;

    String expectedErrorMessage= "bookId 2\n" +
        "Expected: {\"bookId\":\"2\",\"name\":\"Eragon\",\"author\":\"Christopher Paolini\"}\n" +
        makeGreen("  Actual: {\"bookId\":\"2\",\"name\":\"Eragon\",\"author\":\"Christopher Paolini\",\"isbn\":1234}") + "\n" +
        "\nDiff:\n" +
        "JSON path $.\n" +
        "expected does not contain {\"isbn\":1234}\n" +
        wrapWithResetColor("\n") + makeBlue("@@ -1,5 +1,4 @@\n") +
        wrapWithResetColor(" :author => \"Christopher Paolini\",\n") +
        wrapWithResetColor(" :bookId => \"2\",\n") +
        makeRed("-:isbn => 1234,\n") +
        wrapWithResetColor(" :name => \"Eragon\",\n")

    expect(customMatcher.failure_message).to eq(expectedErrorMessage)

    expect(actualArray).not_to eq_json_array_with_key(expectedArray, :bookId)

  end
end