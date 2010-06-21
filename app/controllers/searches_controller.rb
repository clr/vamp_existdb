require 'cgi'

class SearchesController < ApplicationController

  def get
    @results = []
  end

  def post
    # Search term entered.

session = HTTParty.post('http://localhost:8080/exist/tools/sandbox/execute', :headers => {
  'Accept' => 'text/html,application/xhtml+xml,application/xml',
  'X-Requested-With' => 'XMLHttpRequest',
  'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
  'Referer' => 'http://localhost:8080/exist/tools/sandbox/sandbox.xql'
}, :body => { 'qu' => params[:qu] }).headers['set-cookie']

@response = HTTParty.get('http://localhost:8080/exist/tools/sandbox/results/1', :headers => {
  'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
  'X-Requested-With' => 'XMLHttpRequest',
  'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
  'Referer' => 'http://localhost:8080/exist/tools/sandbox/sandbox.xql',
  'Cookie' => session
}).response.body
    render 'get'
  end

  protected
    def prepare_restful_interpretation
      case params[:grammatical_number]
      when 'plural'
        self.action_name = self.request.request_method.to_s.pluralize
      when 'singular'
        params[:resource] ||= allowed_resources[0]
        self.action_name = self.request.request_method.to_s.singularize
      end
    end
    
    # Put search conditions in here.
    def parse_search
      @parse_search ||= ActiveRecord::Base.connection.quote_string( params[:search] || "" )
    end

    def resource_types
      [ 
        [ :image_set, "Images" ],
        [ :video_set, "Video & Audio" ],
        [ :fyle, "Downloads" ],
        [ :news_item, "News" ],
        [ :blog, "Blog Posts" ],
        [ :page, "Pages" ]
      ]
    end
    
    def allowed_resources
      %w( image_set news_item video_set fyle blog page )
    end
end
