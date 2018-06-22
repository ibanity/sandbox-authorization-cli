# Ibanity Sandbox Authorization CLI

This tool can be used in conjunction with the [Ibanity sandbox API](https://documentation.ibanity.com/api). After creating an [account information access request](https://documentation.ibanity.com/api/#account-information-access-request) for a financial institution user(https://documentation.ibanity.com/api/#financial-institution-user), you can run this image as an alternative to manually going through the UI in the Sandbox Authorization Portal.

Once you authorize the account information access request, you can reach the relevant account details at the  [`accounts/`](https://documentation.ibanity.com/api/#list-accounts) and [`transactions/`](https://documentation.ibanity.com/api/#list-transactions) API endpoints.

This image is available on [Docker Hub](https://hub.docker.com/r/ibanity/sandbox-authorization-cli/).

## Setup
```
docker build -t sandbox-authorization-cli .
```

## Run
In order to authorize your account information access request, you will need to provide:
* the uuid of the financial institution it was created for
* the financial institution user's login and password
* the *references* (not uuids) of the accounts you want to authorize
* the redirect link returned when you created the account information access request

```
docker run --rm sandbox-authorization-cli \
account-information-access \
-f FINANCIAL_INSTITUTION_ID \
-l USER_LOGIN \
-p USER_PASSWORD \
-a ACCOUNT_REFERENCE,ACCOUNT_REFERENCE_2,ACCOUNT_REFERENCE_3 \
-r ACCOUNT_INFORMATION_ACCESS_REQUEST_REDIRECT_LINK \
-o HOST* \
-s SSL_CA_FILE*
```
\* optional arguments
