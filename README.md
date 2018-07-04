# Ibanity Sandbox Authorization CLI

This tool supplements the [Ibanity sandbox API](https://documentation.ibanity.com/api).

After creating an [account information access request](https://documentation.ibanity.com/api/#account-information-access-request) for a [financial institution user](https://documentation.ibanity.com/api/#financial-institution-user), you can run this image as an alternative to using the Sandbox Authorization Portal in the browser.

Once the account information access request has been authorized, you can reach the relevant account details at the  [`accounts/`](https://documentation.ibanity.com/api/#list-accounts) and [`transactions/`](https://documentation.ibanity.com/api/#list-transactions) API endpoints.

An image of this CLI is available on [Docker Hub](https://hub.docker.com/r/ibanity/sandbox-authorization-cli/).

## Run
In order to authorize your account information access request, you will need to provide:
* the uuid of the financial institution it was created for
* the financial institution user's login and password
* the references (*not uuids*) of the accounts to authorize
* the redirect link returned when you created the account information access request

```
$ docker run ibanity/sandbox-authorization-cli:latest \
account-information-access \
-f FINANCIAL_INSTITUTION_ID \
-l USER_LOGIN \
-p USER_PASSWORD \
-a ACCOUNT_REFERENCE,ACCOUNT_REFERENCE_2,ACCOUNT_REFERENCE_3 \
-r ACCOUNT_INFORMATION_ACCESS_REQUEST_REDIRECT_LINK \
```

___

If you need to use a host other than `sandbox-authorization.ibanity.com`, you will need to pass some additional arguments in your Docker command.

```
$ docker run \
-v {certificates_directory}/:/usr/local/share/ca-certificates \
--add-host {callback_host}:172.172.172.172 \
--add-host {sandbox_authorization_host}:172.172.172.172 \
sandbox-authorization-cli:latest \
account-information-access \
account-information-access \
-f FINANCIAL_INSTITUTION_ID \
-l USER_LOGIN \
-p USER_PASSWORD \
-a ACCOUNT_REFERENCE,ACCOUNT_REFERENCE_2,ACCOUNT_REFERENCE_3 \
-r ACCOUNT_INFORMATION_ACCESS_REQUEST_REDIRECT_LINK \
-o HOST
```
You should replace `{certificates_directory}` with the path to the directory containing your (domain root and root) CA certificates, and `{callback_host}` and `{sandbox_authorization_host}` with their custom hosts.

`{sandbox_authorization_host}` should match the `-o HOST` argument, which is required in this case.
