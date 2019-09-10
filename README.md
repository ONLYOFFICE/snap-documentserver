[![License](https://img.shields.io/badge/License-GNU%20AGPL%20V3-green.svg?style=flat)](https://www.gnu.org/licenses/agpl-3.0.en.html) [![Snap Status](https://build.snapcraft.io/badge/ONLYOFFICE/snap-documentserver.svg)](https://build.snapcraft.io/user/ONLYOFFICE/snap-documentserver)

## Overview

ONLYOFFICE Document Server is a free collaborative online office suite comprising viewers and editors for texts, spreadsheets and presentations, fully compatible with Office Open XML formats: .docx, .xlsx, .pptx and enabling collaborative editing in real time.

## Functionality

ONLYOFFICE Document Server includes the following editors:

* ONLYOFFICE Document Editor
* ONLYOFFICE Spreadsheet Editor
* ONLYOFFICE Presentation Editor
 
The editors allow you to create, edit, save and export text, spreadsheet and presentation documents.

## Installing ONLYOFFICE Document Server using Snapcraft command line tool

ONLYOFFICE Document Server are available in [Snapcraft store](https://snapcraft.io/onlyoffice-ds) as a snap package. A snap contains all the dependencies to run the application. To use it, all you need is snapd, a system to install and manage snaps. Snapd is included into most of modern distributions. You only need to either enable or install it. See the [official snap project page](https://docs.snapcraft.io/core/install) for the snapd installation instructions.

For example, to install snapd under Ubuntu you need to run the commands:

```
sudo apt update
sudo apt install snapd
```

Also you have to install the PostgreSQL version included in your version of Ubuntu:

sudo apt-get install postgresql
If you want to install some other PostgreSQL version from the PostgreSQL Repository, please see the official PostgreSQL documentation for more detail on that.
After PostgreSQL is installed, create the PostgreSQL database and user:

The created database must have onlyoffice both for user and password.

```
sudo -i -u postgres psql -c "CREATE DATABASE onlyoffice;"
sudo -i -u postgres psql -c "CREATE USER onlyoffice WITH password 'onlyoffice';"
sudo -i -u postgres psql -c "GRANT ALL privileges ON DATABASE onlyoffice TO onlyoffice;"
```

Now the editors can be easily installed using the following command:

```
snap install onlyoffice-ds --beta --devmode
```

## Running ONLYOFFICE Document Server

Once the installation is over, it will be avalible at [http://localhost](http://localhost)

You can check status of ONLYOFFICE Document Server [here](http://localhost/welcome)

## Uninstalling ONLYOFFICE Document Server

To remove the snap containing ONLYOFFICE editors use the following command:

```
snap remove onlyoffice-ds
```

## Running ONLYOFFICE Document Server on Different Port

To change the port, use the `snap set` command.

```
sudo snap set onlyoffice-ds onlyoffice.ds-port=8888
```

## Project Information

Official website: [https://www.onlyoffice.com/apps.aspx](https://www.onlyoffice.com/apps.aspx/?utm_source=github&utm_medium=cpc&utm_campaign=GitHubSnap)

Code repository: [https://github.com/ONLYOFFICE/DocumentServer](https://github.com/ONLYOFFICE/DocumentServer "https://github.com/ONLYOFFICE/DocumentServer")

## User Feedback and Support

If you have any problems with or questions about ONLYOFFICE Document Server, please visit our official forum to find answers to your questions: [dev.onlyoffice.org][1] or you can ask and answer ONLYOFFICE development questions on [Stack Overflow][3].

  [1]: http://dev.onlyoffice.org
  [2]: https://github.com/ONLYOFFICE/DocumentServer
  [3]: http://stackoverflow.com/questions/tagged/onlyoffice