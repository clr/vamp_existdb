class SearchesController < ApplicationController
  def get
    respond_to do |format|
      format.html
      # search token given
      format.xml do
        render :xml => Search.run(Query::PATH.join("#{params[:id]}.xq"))
      end
    end
  end

  # search term entered
  def post
    @query = Query.find_or_create(params[:qu])
    @resource = Search.run(@query.path)
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
