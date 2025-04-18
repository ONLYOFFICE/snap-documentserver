[![License](https://img.shields.io/badge/License-GNU%20AGPL%20V3-green.svg?style=flat)](https://www.gnu.org/licenses/agpl-3.0.en.html)
[![ONLYOFFICE Docs](https://snapcraft.io/onlyoffice-ds/badge.svg)](https://snapcraft.io/onlyoffice-ds)

## Overview

ONLYOFFICE Docs (Document Server) is an open-source office suite that comprises all the tools you need to work with documents, spreadsheets, presentations, PDFs, and PDF forms. The suite supports office files of all popular formats (DOCX, ODT, XLSX, ODS, CSV, PPTX, ODP, etc.) and enables collaborative editing in real time.

## Functionality

ONLYOFFICE Document Server includes the following editors:

* ONLYOFFICE Document Editor
* ONLYOFFICE Spreadsheet Editor
* ONLYOFFICE Presentation Editor
 
The editors allow you to create, edit, save and export text, spreadsheet and presentation documents.

## Installing ONLYOFFICE Document Server using Snapcraft command line tool

ONLYOFFICE Document Server is available in [Snapcraft store](https://snapcraft.io/onlyoffice-ds) as a snap package. A snap contains all the dependencies to run the application. To use it, all you need is snapd, a system to install and manage snaps. Snapd is included into most of modern distributions. You only need to either enable or install it. See the [official snap project page](https://docs.snapcraft.io/core/install) for the snapd installation instructions.

For example, to install snapd under Ubuntu you need to run the commands:

```
# apt update
# apt install snapd
```

Now the editors can be easily installed using the following command:

```
# snap install onlyoffice-ds
```

## Running ONLYOFFICE Document Server

Once the installation is over, ONLYOFFICE Document Server will be avalible at [http://localhost](http://localhost)

You can check status of ONLYOFFICE Document Server [here](http://localhost/welcome)

## Uninstalling ONLYOFFICE Document Server

To remove the snap containing ONLYOFFICE editors use the following command:

```
# snap remove onlyoffice-ds
```

## Configuration

### Running ONLYOFFICE Document Server on Different Port

By default, the snap will listen on port 80. If you'd like to change the HTTP port (say, to port 8888), run:

```
# snap set onlyoffice-ds onlyoffice.ds-port=8888
```

### MySQL port configuration

By default, MySQL uses port 3306. You can also change the database port, using the command:

```
# snap set onlyoffice-ds onlyoffice.db-port=3307
```

### Running ONLYOFFICE Document Server using HTTPS

Access to the onlyoffice application can be secured using SSL so as to prevent unauthorized access. While a CA certified SSL certificate allows for verification of trust via the CA, a self signed certificates can also provide an equal level of trust verification as long as each client takes some additional steps to verify the identity of your website. Below the instructions on achieving this are provided.

To secure the application via SSL basically two things are needed:

- **Private key (.key)**
- **SSL certificate (.crt)**

When using CA certified certificates, these files are provided to you by the CA. When using self-signed certificates you need to generate these files yourself. Skip the following section if you are have CA certified SSL certificates.

#### Generation of Self Signed Certificates

Generation of self-signed SSL certificates involves a simple 3 step procedure.

**STEP 1**: Create the server private key

```
$ openssl genrsa -out onlyoffice.key 2048
```

**STEP 2**: Create the certificate signing request (CSR)

```
$ openssl req -new -key onlyoffice.key -out onlyoffice.csr
```

**STEP 3**: Sign the certificate using the private key and CSR

```
$ openssl x509 -req -days 365 -in onlyoffice.csr -signkey onlyoffice.key -out onlyoffice.crt
```

You have now generated an SSL certificate that's valid for 365 days.

If you'd like to use Example with Self Signed Certificates then you need to [allow to use unauthorized storage](#allow-document-server-to-use-unauthorized-storage).

#### Strengthening the server security

This section provides you with instructions to [strengthen your server security](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html).
To achieve this you need to generate stronger DHE parameters.

```
$ openssl dhparam -out dhparam.pem 2048
```

#### Installation of the SSL Certificates

Out of the four files generated above, you need to install the `onlyoffice.key`, `onlyoffice.crt` and `dhparam.pem` files at the onlyoffice server. The CSR file is not needed, but do make sure you safely backup the file (in case you ever need it again).

The default path that the onlyoffice application is configured to look for the SSL certificates is at `/var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/certs`.

The `/var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/` path is the path of the data store, which means that you have to copy the files into it.

```
# cp onlyoffice.key /var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/certs/
# cp onlyoffice.crt /var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/certs/
# cp dhparam.pem /var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/certs/
```

Then you must restart ONLYOFFICE Document Server to work on ssl, run:

```
# snap restart onlyoffice-ds
```

You are now just one step away from having our application secured.

If you want to return ONLYOFFICE Document Server to work on HTTP, delete files from the `/var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/certs` and restart ONLYOFFICE Document Server.

```
# rm /var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/certs/onlyoffice.*
# rm /var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/certs/dhparam.pem
# snap restart onlyoffice-ds
```

#### Running ONLYOFFICE Document Server on Different SSL Port

By default, HTTPS SSL port is 443. If you'd like to change it (say, to port 444), run:

```
# snap set onlyoffice-ds onlyoffice.ds-ssl-port=444
```

#### Allow document server to use unauthorized storage

By default, document server is prevented from using an unauthorized storage. To allow it, run:

```
# snap set onlyoffice-ds onlyoffice.use-unautorized-storage=true
```

#### Set document server to run on loopback interface

By default, document server do not run on loopback interface. To set it, run:

```
# snap set onlyoffice-ds onlyoffice.loopback=true
```

#### JSON Web Token

- **jwt-enabled**: Specifies the enabling the JSON Web Token validation by the ONLYOFFICE Document Server. Defaults to `true`.
- **jwt-secret**: Defines the secret key to validate the JSON Web Token in the request to the ONLYOFFICE Document Server. Random string by default.
- **jwt-header**: Defines the http header that will be used to send the JSON Web Token. Defaults to `Authorization`.

If you'd like to change the JSON Web Token parameters, run:

```
# snap set onlyoffice-ds onlyoffice.key=value
```

#### Allow document server to use WOPI protocol

By default, document server is prevented from using a WOPI protocol. To allow it, run:

```
# snap set onlyoffice-ds onlyoffice.wopi=true
```

### Enabling the Example

By default, example is not enabled. You can enable the example, using the command:

```
# snap set onlyoffice-ds onlyoffice.example-enabled=true
```

## Project Information

Official website: [https://www.onlyoffice.com/apps.aspx](https://www.onlyoffice.com/apps.aspx/?utm_source=github&utm_medium=cpc&utm_campaign=GitHubSnap)

Code repository: [https://github.com/ONLYOFFICE/DocumentServer](https://github.com/ONLYOFFICE/DocumentServer "https://github.com/ONLYOFFICE/DocumentServer")

## User Feedback and Support

If you have any problems with or questions about ONLYOFFICE Document Server, please visit our official forum to find answers to your questions: [forum.onlyoffice.com][1] or you can ask and answer ONLYOFFICE development questions on [Stack Overflow][3].

  [1]: https://forum.onlyoffice.com
  [2]: https://github.com/ONLYOFFICE/DocumentServer
  [3]: http://stackoverflow.com/questions/tagged/onlyoffice
