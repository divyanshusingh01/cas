#!/bin/bash
cd /tmp
mkdir jetpatch
cd jetpatch
wget "https://connector-deployment.s3.amazonaws.com/Connectors/Linux/vlink_installer_linux_x64_4.1.2.230_Release.bsx" -outfile vlink_installer_linux_x64_4.1.2.230_Release.bsx
chmod +x vlink_installer_linux_x64_4.1.2.230_Release.bsx

./vlink_installer_linux_x64_4.1.2.230_Release.bsx

systemctl start intigua 
