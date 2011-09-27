require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  def setup
    @query_path = Rails.root.join('test','fixtures','default_query.xq')
    @default_response = File.open(Rails.root.join('test','fixtures','default_response.xml'),'r').read.chop
  end

  test "that we can query the local database" do
    assert_equal @default_response, Search.run(@query_path), "This was not the search result we wanted."
  end
end
