class Query
  PATH = Rails.root.join('queries')

  attr_reader :hash, :path

  class << self
    def find(query_string)
      new_query = Query.new(query_string)
      return File.exists?(new_query.path) ? new_query : false
    end

    def create(query_string)
      new_query = Query.new(query_string)
      File.open(new_query.path,'w'){|f| f.write(query_string)}
      new_query
    end

    def find_or_create(query_string)
      find(query_string) || create(query_string)
    end
  end

  def initialize(query_string)
    @query_string = query_string
    hash = Digest::SHA2.new(256)
    hash << @query_string
    @hash = hash.to_s
    @path = PATH.join("#{@hash}.xq")
  end
end
