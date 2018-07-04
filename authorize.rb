require 'optparse'
require_relative "account_information_access_authorization"

options = {}
command = ARGV[0]

case command
when "account-information-access"
  OptionParser.new do |parser|
    parser.banner = "Usage: account-information-access [arguments]"
    parser.on("-h", "--help", "Show this help message") do ||
      puts parser
      exit
    end
    parser.on("-f", "--financial-institution-id FINANCIAL_INSTITUTION_ID", "UUID of the financial institution holding the account to be authorized") do |v|
      options[:financial_institution_id] = v
    end

    parser.on("-l", "--user-login USER_LOGIN", "Financial institutiton user's login") do |v|
      options[:user_login] = v
    end

    parser.on("-p", "--user-password USER_PASSWORD", "Financial institutiton user's password") do |v|
      options[:user_password] = v
    end

    parser.on("-a", "--account-references ACCOUNT_REFERENCE,ACCOUNT_REFERENCE_2,ACCOUNT_REFERENCE_3", "Comma-separated list of reference values for the financial institution accounts to be authorized (not their UUIDs)") do |v|
      options[:account_references] = v
    end

    parser.on("-r", "--account-information-access-request-redirect-link ACCOUNT_INFORMATION_ACCESS_REQUEST_REDIRECT_LINK", "Redirect URI from the created account information access request") do |v|
      options[:account_information_access_request_redirect_link] = v
    end

    options[:host] = "sandbox-authorization.ibanity.com"
    parser.on("-o", "--host HOST", "[OPTIONAL] Custom Sandbox Authorization host (default: sandbox-authorization.ibanity.com)") do |v|
      options[:host] = v
    end
  end.parse!
else
  abort("Usage: command [arguments]

Available commands are:
 account-information-access :     authorizes a created account information access request

See 'COMMAND --help' for more information on a specific command.")
end

[:financial_institution_id, :user_login, :user_password, :account_references, :account_information_access_request_redirect_link].each do |argument|
  raise OptionParser::MissingArgument.new(argument) if options[argument].nil?
end

account_references = options[:account_references].split(",")

AccountInformationAccessAuthorization.new(financial_institution_id: options[:financial_institution_id], user_login: options[:user_login], user_password: options[:user_password], account_references: account_references, account_information_access_request_redirect_link: options[:account_information_access_request_redirect_link], host: options[:host]).execute

puts "Your authorization has been submitted."
