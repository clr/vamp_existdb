require 'cgi'

class SearchesController < ApplicationController

  def get
    respond_to do |format|
      format.html
      format.xml do
        @resource = Search.find_by_token(params[:id])
        @resource.fetch_result!
      end
    end
  end

  def post
    # Search term entered.
    @resource = Search.create(:query => params[:qu])
    @resource.fetch_result!
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
    
end
