class Search < ActiveRecord::Base
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
    session = HTTParty.post('http://localhost:8080/exist/sandbox/execute', :headers => {
      'Accept' => 'text/html,application/xhtml+xml,application/xml',
      'X-Requested-With' => 'XMLHttpRequest',
      'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
      'Referer' => 'http://localhost:8080/exist/sandbox/sandbox.xql'
    }, :query => { 'qu' => self.query }).headers['set-cookie']

    self.response_body = HTTParty.get('http://localhost:8080/exist/sandbox/results/1', :headers => {
      'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'X-Requested-With' => 'XMLHttpRequest',
      'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
      'Referer' => 'http://localhost:8080/exist/sandbox/sandbox.xql',
      'Cookie' => session
    }).response.body
  end

  def result
    self.response_body.gsub(/<[^(<)][^(>|\/>)]+>/, '')
  end
end
