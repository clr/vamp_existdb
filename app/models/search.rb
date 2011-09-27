class Search
  class << self
    def run(query_path)
      return false unless File.exist?(query_path)

      @response = `#{EXIST_CLIENT} -u admin -P secret -F #{query_path}`
      @response = @response.split("\n")[7..-1].join("\n")
    end
  end

  attr_accessor :response_body

  def self.create(attrs)
    self.where(:query => attrs[:query]).first || super(attrs)
  end

  def self.find_by_token(token)
    self.find token.to_i(36)
  end

  def token
    self.id.to_s(36)
  end

  def to_param
    self.token
  end

  def fetch_result!
#    session = HTTParty.post('http://localhost:8080/exist/sandbox/execute', :headers => {
#    raise HTTParty.post('http://localhost:8080/exist/rto/show', :headers => {
    return HTTParty.post('http://localhost:8080/exist/rto/try', :headers => {
#    return HTTParty.post('http://localhost:8080/exist/functions/', :headers => {
      'Accept' => 'text/html,application/xhtml+xml,application/xml',
      'X-Requested-With' => 'XMLHttpRequest',
      'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
      'Referer' => 'http://localhost:8080/exist/rto/rto.xql'
    }, :query => { 'qu' => self.query }).parsed_response
#    }).response.body
  end

  def old_fetch_result!
#    session = HTTParty.post('http://localhost:8080/exist/sandbox/execute', :headers => {
    session = HTTParty.post('http://localhost:8080/exist/rto/execute', :headers => {
      'Accept' => 'text/html,application/xhtml+xml,application/xml',
      'X-Requested-With' => 'XMLHttpRequest',
      'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
#      'Referer' => 'http://localhost:8080/exist/sandbox/sandbox.xql'
      'Referer' => 'http://localhost:8080/exist/rto/rto.xql'
    }, :query => { 'qu' => self.query }).headers['set-cookie']

#    self.response_body = HTTParty.get('http://localhost:8080/exist/sandbox/results/1', :headers => {
    self.response_body = HTTParty.get('http://localhost:8080/exist/rto/results/1', :headers => {
      'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'X-Requested-With' => 'XMLHttpRequest',
      'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
#      'Referer' => 'http://localhost:8080/exist/sandbox/sandbox.xql',
      'Referer' => 'http://localhost:8080/exist/rto/rto.xql',
      'Cookie' => session
    }).response.body
  end
  def result
    self.response_body.gsub(/<[^(<)][^(>|\/>)]+>/, '')
  end
end
