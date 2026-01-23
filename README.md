# 📦 Snap for ONLYOFFICE Docs

[![License](https://img.shields.io/badge/License-GNU%20AGPL%20V3-green.svg?style=flat)](https://www.gnu.org/licenses/agpl-3.0.en.html)
[![ONLYOFFICE Docs](https://snapcraft.io/onlyoffice-ds/badge.svg)](https://snapcraft.io/onlyoffice-ds)

## ✨ Overview

[**ONLYOFFICE Docs**](https://www.onlyoffice.com/docs?utm_source=github&utm_medium=cpc&utm_campaign=GitHubSnapDS) (Document Server) is a powerful **open-source office suite** for real-time document collaboration. It enables you to:

- Create and edit documents, spreadsheets, presentations, and PDFs
- Collaborate with multiple users simultaneously
- Work with all popular office formats (DOCX, ODT, XLSX, ODS, CSV, PPTX, ODP, etc.)

💡 **Why Snap?**

The **Snap** package bundles all dependencies, making installation, updates, and management seamless across Linux distributions.

## 🛠️ Core Editors

ONLYOFFICE Docs includes a full set of editors and tools:

- [**Document Editor**](https://www.onlyoffice.com/word-processor?utm_source=github&utm_medium=cpc&utm_campaign=GitHubSnapDS) – Create, edit, save, and export text documents
- [**Spreadsheet Editor**](https://www.onlyoffice.com/sheets?utm_source=github&utm_medium=cpc&utm_campaign=GitHubSnapDS) – Work with spreadsheets in real time
- [**Presentation Editor**](https://www.onlyoffice.com/slides?utm_source=github&utm_medium=cpc&utm_campaign=GitHubSnapDS) – Build and share presentations
- [**PDF Editor**](https://www.onlyoffice.com/pdf-editor?utm_source=github&utm_medium=cpc&utm_campaign=GitHubSnapDS) – View and edit PDFs
- [**Form Creator**](https://www.onlyoffice.com/form-creator?utm_source=github&utm_medium=cpc&utm_campaign=GitHubSnapDS) – Design fillable online forms
- [**Diagram Viewer**](https://www.onlyoffice.com/diagram-viewer?utm_source=github&utm_medium=cpc&utm_campaign=GitHubSnapDS) – View diagrams embedded in documents

---

## 🚀 Installation Guide

### 1. Ensure `snapd` is available

ONLYOFFICE Docs is available in the [Snapcraft store](https://snapcraft.io/onlyoffice-ds). Snap packages contain all dependencies, so setup is simple.

To use Snap packages, you need **snapd**, a system to install and manage snaps. Most modern Linux distributions include `snapd` by default; you may only need to enable or install it.

If missing, install it. Example for Ubuntu/Debian:

```bash
# apt update
# apt install snapd
```

👉 For other distributions, see the [official snapd installation guide](https://snapcraft.io/docs/installing-snapd)

### 2. Install ONLYOFFICE Docs

Once snapd is ready, install ONLYOFFICE Docs with the following command:

```bash
# snap install onlyoffice-ds
```

The Document Server and all required dependencies are now installed.

## ▶️ Running ONLYOFFICE Docs

After installation, the service starts automatically.

- Open the editor in your browser: [http://localhost](http://localhost)
- Access the status page: [http://localhost/welcome](http://localhost/welcome)

To check service status:

```bash
# snap services onlyoffice-ds
```

To restart service :

```bash
# snap restart onlyoffice-ds
```

## ⚙️ Configuration

### Running ONLYOFFICE Document Server on a different port

By default, the snap listens to port 80. If you'd like to change the HTTP port (e.g., to port 8888), run:

```
# snap set onlyoffice-ds onlyoffice.ds-port=8888
```

### MySQL port configuration

By default, MySQL uses port 3306. You can also change the database port:

```
# snap set onlyoffice-ds onlyoffice.db-port=3307
```

### 🔐 Running ONLYOFFICE Document Server using HTTPS

Access to ONLYOFFICE can be secured with SSL to prevent unauthorized access. While a CA-certified SSL certificate ensures trust verification through the certificate authority, self-signed certificates can offer a similar level of trust, provided each client takes additional steps to verify your website's identity. Follow the instructions below for guidance.

To secure the application via SSL, basically two things are needed:

- **Private key (.key)**
- **SSL certificate (.crt)**

When using CA-certified certificates, the necessary files are provided by the certificate authority. For self-signed certificates, you’ll need to generate these files yourself. If you already have CA-certified SSL certificates, you can skip the following section.

#### Generation of self-signed certificates

Generating self-signed SSL certificates is a straightforward three-step process.

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

You have now generated an SSL certificate which is valid for 365 days.

If you'd like to use Example with Self-Signed Certificates, you need to [allow using unauthorized storage](#allow-document-server-to-use-unauthorized-storage).

#### Strengthening the server security

This section offers instructions to [enhance your server's security](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html). To do so, you'll need to generate stronger DHE parameters.

```
$ openssl dhparam -out dhparam.pem 2048
```

#### Installation of the SSL Certificates

From the four files generated above, you need to install `onlyoffice.key`, `onlyoffice.crt` and `dhparam.pem` on the ONLYOFFICE server. The CSR file is not required, but be sure to back it up securely in case it’s needed in the future.

The default path where the ONLYOFFICE application is configured to locate SSL certificates is `/var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/certs`.

The path `/var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/` serves as the data storage, meaning you’ll need to copy the files into this directory.

```
# cp onlyoffice.key /var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/certs/
# cp onlyoffice.crt /var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/certs/
# cp dhparam.pem /var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/certs/
```

Then, restart ONLYOFFICE Document Server to work on SSL:

```
# snap restart onlyoffice-ds
```

You are now just one step away from having the application secured.

To revert the ONLYOFFICE Document Server to operate over HTTP, delete the files from `/var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/certs` and restart the server.

```
# rm /var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/certs/onlyoffice.*
# rm /var/snap/onlyoffice-ds/current/var/www/onlyoffice/Data/certs/dhparam.pem
# snap restart onlyoffice-ds
```

#### Running ONLYOFFICE Document Server on a different SSL port

By default, HTTPS SSL port is 443. If you'd like to change it (e.g., to port 444), run:

```
# snap set onlyoffice-ds onlyoffice.ds-ssl-port=444
```

#### Allow ONLYOFFICE to use unauthorized storage

By default, the Document Server is prevented from using an unauthorized storage. To allow it, run:

```
# snap set onlyoffice-ds onlyoffice.use-unautorized-storage=true
```

#### Set Document Server to run on loopback interface

By default, the Document Server doesn't run on loopback interface. To set it, run:

```
# snap set onlyoffice-ds onlyoffice.loopback=true
```

#### 🔑 JSON Web Token

- **jwt-enabled**: Specifies the enabling the JSON Web Token validation by the ONLYOFFICE Document Server. Defaults to `true`.
- **jwt-secret**: Defines the secret key to validate the JSON Web Token in the request to the ONLYOFFICE Document Server. Random string by default.
- **jwt-header**: Defines the http header that will be used to send the JSON Web Token. Defaults to `Authorization`.

If you'd like to change the JSON Web Token parameters, run:

```
# snap set onlyoffice-ds onlyoffice.key=value
```

#### Allow Document Server to use WOPI protocol

By default, the Document Server is prevented from using a WOPI protocol. To allow it, run:

```
# snap set onlyoffice-ds onlyoffice.wopi=true
```

### Enabling the example

By default, a test example is not enabled. You can enable it using the command:

```
# snap set onlyoffice-ds onlyoffice.example-enabled=true
```
### Enabling the Admin Panel

By default, the Admin Panel is not enabled. To enable the Admin Panel, use the command:

```
# snap set onlyoffice-ds onlyoffice.adminpanel-enabled=true
```

### Uninstall ONLYOFFICE Docs

To remove the snap containing ONLYOFFICE Docs, use the following command:

```bash
# snap remove onlyoffice-ds
```

## 📌 Project links

🌍 Official Website: [ONLYOFFICE Docs](https://www.onlyoffice.com/docs?utm_source=github&utm_medium=cpc&utm_campaign=GitHubSnapDS)

💾 Code repository: [ONLYOFFICE Docs main repo](https://github.com/ONLYOFFICE/DocumentServer)

🧑‍💻 ONLYOFFICE API: Check out [developer documentation](https://api.onlyoffice.com/?utm_source=github&utm_medium=cpc&utm_campaign=GitHubSnapDS)

## 💬 Support & Community

Need help or want to discuss ONLYOFFICE Docs? Join our community:

- 🛠 Forum: [ONLYOFFICE Community](https://community.onlyoffice.com/)
- 🐛 GitHub Issues: [Report issues](https://github.com/ONLYOFFICE/snap-documentserver/issues)
- 💬 Feedback platform: [feedback.onlyoffice.com](https://feedback.onlyoffice.com/forums/966080-your-voice-matters).

---