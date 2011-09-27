require 'test_helper'

class QueryTest < ActiveSupport::TestCase
  def setup
    @query_string = File.readlines(Rails.root.join('test','fixtures','default_query.xq')).join("\n")
    @faux_query_path = Query::PATH.join("f74634aa976bac53ec53db82dc43bfe27b5661039d43f5457593dfa0284bf2ce.xq")
    File.delete @faux_query_path if File.exists?(@faux_query_path)
  end

  def teardown
    File.delete @faux_query_path if File.exists?(@faux_query_path)
  end

  test "we get a valid file name from the query contents" do
    assert_equal Query::PATH.join("317032f1b65f547caaf03ec37eefe89916e8a1967d226c10a6dbb5a530dcff55.xq"), Query.new(@query_string).path
  end

  test "we create a new query file" do
    faux_query_string = "This is a faux query."
    # create the query
    Query.create(faux_query_string)
    assert File.exist?(@faux_query_path), "Query file was not created."
    assert_equal faux_query_string, File.readlines(@faux_query_path)[0]
  end

  test "we can find a query file" do
    faux_query_string = "This is another faux query."
    Query.create(faux_query_string)
    query = Query.find(faux_query_string)
    assert_equal faux_query_string, File.readlines(query.path)[0]
  end

  test "we can't find a query file that doesn't exist" do
    assert !Query.find("Never going to query for this."), "Should not have been able to find non-existent query."
  end

  test "we can find or create in one go" do
    # create the query
    query = Query.find_or_create("This is a faux query.")
    assert File.exist?(@faux_query_path), "Query file was not created."
    # find the query again
    query = Query.find_or_create("This is a faux query.")
    assert File.exist?(@faux_query_path), "Query file was not found."
  end
end
