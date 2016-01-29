require 'faraday'
require 'faraday_middleware'

class SierraApi
  API_BASE = 'https://sierra-app.dartmouth.edu/iii/sierra-api/v2'.freeze

  # ---Make the API request. 'mytoken' is derived above from the initial OAuth request. ---
  # newheaders = {'GET': thisurl,
  #               'Host': 'sierra-app.dartmouth.edu',
  #               'Authorization': 'Bearer ' + mytoken,
  #               'User-Agent': 'MyAppName'}
  #
  # r = requests.get(thisurl, headers=newheaders)

  # initialize method that takes care of authenticating the connection
  def initialize
    authenticate()

    @connection = Faraday.new(API_BASE, ssl: {verify: true}) do |conn|
      conn.headers = {
        'Host'          => 'sierra-app.dartmouth.edu',
        'Authorization' => "Bearer #{@access_token}",
        'User-Agent'    => 'JonesKiosk'
      }

      conn.request  :json
      conn.response :json, :content_type => /\bjson$/

      conn.adapter Faraday.default_adapter
    end
  end

  def bibs(id:)
    authenticate
    response = @connection.get("bibs/#{id}/marc")
    print response.body
  end

  def item
  end

  # before each request it should check that the token has not expired and if it has
  # we should attempt to authenticate again
  #
  private

  # Get authentication token and save when this token will expire.
  def authenticate
    if authentication_expired?
      credentials = Base64.strict_encode64(ENV['SIERRA_API_KEY'] + ':' + ENV['SIERRA_API_SECRET'])
      # throw error if api key or secret key is missing.

      response = Faraday.post(API_BASE + '/token') do |req|
        req.headers['Host']          = 'catalog-lib.dartmouth.edu'
        req.headers['Authorization'] = "Basic #{credentials}"
        req.headers['Content-Type']  = 'application/x-www-form-urlencoded'
        req.body { 'grant_type=client_credentials' }
      end
      body = JSON.parse(response.body)

      # if response is sucessful
      @access_token = body['access_token']
      @expires_in = Time.now + (body['expires_in'] - 10)
      # return true
      # else return false

    end
  end

  def authentication_expired?
    !@expired_in.present? || @expired_in < Time.now
  end
end
