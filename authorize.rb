require 'optparse'
require_relative "account_information_access_authorization"

options = {}
command = ARGV[0]

case command
when "account-information-access"
  OptionParser.new do |parser|
    parser.banner = "Usage: ruby authorize.rb account-information-access [arguments]"
    parser.on("-h", "--help", "Show this help message") do ||
      puts parser
      exit
    end
    parser.on("-f", "--financial-institution-id FINANCIAL_INSTITUTION_ID", "UUID for the associated financial institution") do |v|
      options[:financial_institution_id] = v
    end

    parser.on("-l", "--user-login USER_LOGIN", "User's fake financial institution login") do |v|
      options[:user_login] = v
    end

    parser.on("-p", "--user-password USER_PASSWORD", "User's fake financial institution password") do |v|
      options[:user_password] = v
    end

    parser.on("-a", "--account-reference ACCOUNT_REFERENCE", "Financial institution's internal reference for the financial institution account to be authorized") do |v|
      options[:account_reference] = v
    end

    parser.on("-r", "--account-information-access-request-redirect-link ACCOUNT_INFORMATION_ACCESS_REQUEST_REDIRECT_LINK", "URI returned when the account information access request is created") do |v|
      options[:account_information_access_request_redirect_link] = v
    end
  end.parse!
else
  abort("Usage: authorize.rb command [arguments]

Available commands are:
 account-information-access :     authorizes a created account information access request

See 'authorize.rb COMMAND --help' for more information on a specific command.")
end

[:financial_institution_id, :user_login, :user_password, :account_reference, :account_information_access_request_redirect_link].each do |argument|
  raise OptionParser::MissingArgument.new(argument) if options[argument].nil?
end

AccountInformationAccessAuthorization.new(financial_institution_id: options[:financial_institution_id], user_login: options[:user_login], user_password: options[:user_password], account_reference: options[:account_reference], account_information_access_request_redirect_link: options[:account_information_access_request_redirect_link]).execute

puts "Your authorization has been submitted."
