# frozen_string_literal: true

require "json"
require "uri"
require "rest-client"

module MonzoAdaptor
  # OAuth2 client for the Monzo API.
  #
  # This deliberately does not build on ApiAdaptor::Base: Monzo's OAuth2
  # token endpoint requires application/x-www-form-urlencoded request
  # bodies, while ApiAdaptor::JSONClient always sends JSON.
  #
  # Exposes non-interactive primitives only — building the authorize URL,
  # exchanging a code, refreshing, and logging out. Launching a browser,
  # capturing the redirect, and polling for Strong Customer Authentication
  # approval are all consumer concerns.
  #
  # @see https://docs.monzo.com/#authentication
  class OAuth
    # Raised when a request to the Monzo OAuth2 endpoints fails
    class AuthenticationError < MonzoAdaptor::Error
      # @return [Integer] the HTTP status code returned by Monzo
      attr_reader :http_code

      # @return [String] the raw response body returned by Monzo
      attr_reader :http_body

      def initialize(http_code, http_body)
        @http_code = http_code
        @http_body = http_body
        super("Monzo OAuth request failed with status #{http_code}: #{http_body}")
      end
    end

    AUTHORIZE_URL = "https://auth.monzo.com/"
    TOKEN_URL = "https://api.monzo.com/oauth2/token"
    LOGOUT_URL = "https://api.monzo.com/oauth2/logout"

    # @return [String] the client ID
    attr_reader :client_id

    # @return [String] the redirect URI
    attr_reader :redirect_uri

    # Builds the URL to send a user to in order to authorise this app
    #
    # @param [String] client_id Your client ID
    # @param [String] redirect_uri Where Monzo should redirect the user after authorisation
    # @param [String] state An unguessable random string, checked on redirect back to protect against CSRF
    #
    # @return [String] the authorization URL
    def self.authorize_url(client_id:, redirect_uri:, state:)
      uri = URI(AUTHORIZE_URL)
      uri.query = URI.encode_www_form(
        client_id: client_id,
        redirect_uri: redirect_uri,
        response_type: "code",
        state: state
      )
      uri.to_s
    end

    def initialize(client_id:, client_secret:, redirect_uri:)
      @client_id = client_id
      @client_secret = client_secret
      @redirect_uri = redirect_uri
    end

    # Exchanges a temporary authorization code for an access token
    #
    # @param [String] code The authorization code received via the redirect_uri
    #
    # @return [Hash] the token response (access_token, refresh_token, expires_in, ...)
    def exchange_code(code)
      post_token(
        grant_type: "authorization_code",
        client_id: client_id,
        client_secret: client_secret,
        redirect_uri: redirect_uri,
        code: code
      )
    end

    # Exchanges a refresh token for a new access token
    #
    # @param [String] refresh_token The refresh token received with the original access token
    #
    # @return [Hash] the token response (access_token, refresh_token, expires_in, ...)
    def refresh(refresh_token)
      post_token(
        grant_type: "refresh_token",
        client_id: client_id,
        client_secret: client_secret,
        refresh_token: refresh_token
      )
    end

    # Invalidates an access token immediately
    #
    # @param [String] access_token The access token to invalidate
    #
    # @return [Boolean] true if the token was invalidated
    def logout(access_token)
      RestClient.post(LOGOUT_URL, "", "Authorization" => "Bearer #{access_token}")
      true
    rescue RestClient::ExceptionWithResponse => e
      raise AuthenticationError.new(e.response.code, e.response.body)
    end

    private

    attr_reader :client_secret

    def post_token(params)
      response = RestClient.post(TOKEN_URL, params)
      JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
      raise AuthenticationError.new(e.response.code, e.response.body)
    end
  end
end
