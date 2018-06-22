# Ibanity Sandbox Authorization CLI

You can use this CLI to authorize an account information access request in the sandbox without having to use the sandbox authorization portal.

## Setup
```
docker build -t sandbox-authorization-cli .
```

## Run
```
docker run --rm sandbox-authorization-cli \
account-information-access \
-f FINANCIAL_INSTITUTION_ID \
-l USER_LOGIN \
-p USER_PASSWORD \
-a ACCOUNT_REFERENCE,ACCOUNT_REFERENCE_2,ACCOUNT_REFERENCE_3 \
-r ACCOUNT_INFORMATION_ACCESS_REQUEST_REDIRECT_LINK
```
