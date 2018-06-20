require "json"
require "uri"
require "rest-client"

class AccountInformationAccessAuthorization
  def initialize(financial_institution_id:, user_login:, user_password:, account_reference:, account_information_access_request_redirect_link:)
    @financial_institution_id = financial_institution_id
    @user_login = user_login
    @user_password = user_password
    @account_reference = account_reference
    @account_information_access_request_redirect_link = account_information_access_request_redirect_link
  end

  def execute
    get_redirect_parameters
    create_authentication
    create_verification
    link_access_request_to_user
    authorize_account_access
    sign_access_request
  end

private

  def get_redirect_parameters
    query = {
      method: :get,
      url: @account_information_access_request_redirect_link,
      max_redirects: 0,
      verify_ssl: false
    }
    begin
      RestClient::Request.execute(query)
    rescue RestClient::ExceptionWithResponse => err
    end
    redirect = err.response.headers[:location]
    redirect_parameters = URI.decode_www_form(URI.parse(redirect).query).to_h
    @redirect_uri = redirect_parameters["redirectUri"]
    @application_id = redirect_parameters["applicationId"]
    @sandbox_account_information_access_request_id = redirect.match(/\/account-information-access-requests\/(.+)\?/)[1]
  end

  def create_authentication
    payload = {
      data: {
        attributes: {
          applicationId: @application_id,
          login: @user_login,
          password: @user_password
        }
      }
    }
    response = consent_api_call(method: :post, endpoint: "authentications", payload: payload)
    @authentication_id = response["data"]["id"]
  end

  def create_verification
    payload = {
      data: {
        attributes: {
          applicationId: @application_id,
          id: @authentication_id,
          response: "123456"
        }
      }
    }
    response = consent_api_call(method: :post, endpoint: "verifications", payload: payload)
    @session_token = response["data"]["attributes"]["sessionToken"]
  end

  def link_access_request_to_user
    consent_api_call(
      method: :patch,
      endpoint: "account-information-access-requests/#{@sandbox_account_information_access_request_id}/relationships/user",
      headers: true,
      skip_parse: true
    )
  end

  def authorize_account_access
    consent_api_call(
      method: :patch,
      endpoint: "account-information-access-requests/#{@sandbox_account_information_access_request_id}",
      headers: true,
      payload: {
        data: {
          type: "accountInformationAccessRequest",
          attributes: {
            requestedAccountReferences: [
              @account_reference
            ]
          }
        }
      },
      skip_parse: true
    )
  end

  def sign_access_request
    response = consent_api_call({
      method: :post,
      endpoint: "account-information-access-requests/#{@sandbox_account_information_access_request_id}/signatures",
      headers: true,
      payload: {
        data: {
          type: "accountInformationAccessRequest",
          attributes: {
            redirectUri: @redirect_uri,
            response: "123456"
          }
        }
      }
    })
    redirect_url = response["data"]["attributes"]["redirectUri"]

    begin
      RestClient::Request.execute({method: :get, max_redirects: 0, url: redirect_url, verify_ssl: false})
    rescue RestClient::ExceptionWithResponse => err
    end
  end

  def consent_api_call(method:, endpoint:, headers: false, payload: {}, skip_parse: false)
    basic_headers = {
      content_type:  :json,
      accept:        :json
    }
    basic_headers.merge!({ authorization: "Bearer #{@session_token}"}) if headers
    response = RestClient::Request.execute({
      method: method,
      url: "https://sandbox-authorization.ibanity.com/api/financial-institutions/#{@financial_institution_id}/#{endpoint}",
      verify_ssl: false,
      payload: payload ? payload.to_json : nil,
      headers: basic_headers
    })
    JSON.parse(response) unless skip_parse
  end
end
