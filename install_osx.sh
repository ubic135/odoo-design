#!/bin/bash

ODOO="~/odoo"

# Will install xcode and ask for license agreement
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Normally the installer will do this but a custom bash configuration could break it.
PATH="/usr/local/bin:$PATH"
export PATH

brew doctor
brew install git bzr pyqt postgresql node dialog libjpeg

# Bazaar is used by git-qdiff
BZR='~/.bazaar/plugins'
mkdir -p $BZR
cd $BZR
bzr branch lp:qbzr

# TODO: Check that the git account is configured + give access to odoo/design-themes branch
mkdir -p $ODOO
cd $ODOO
git clone git@github.com:odoo-dev/odoo-design.git odoo
git clone git@github.com:odoo/design-themes.git design-themes

# Install openerp
pip install -r $ODOO/odoo/requirements.txt

pip install watchdog pyqt # had a problem with brew's pyqt and has to use pypi's one

npm install -g less

# Create start script
cd ~/
START=~/start.sh
cat > $START << EOF
#!/bin/bash
$ODOO/odoo/start
EOF
chmod +x $START

dialog --msgbox "You're ready to work on odoo's themes.\n\nIn order to start the server, just open a terminal and type this command:\n\n  $START" 10 45
