YoNTMA
======

YoNTMA (You'll Never Take Me Alive!) is a tool designed to enhance the protection of data encryption on laptops.

How It Works
------------

YoNTMA runs as a status bar icon on FileVault-protected laptops. If the laptop is disconnected from AC power or wired Ethernet while the screen is locked, YoNTMA puts the system into hibernate. This prevents a laptop thief from accessing your encrypted data later via a DMA attack while the machine is still powered on and the encryption keys are in memory, and reduces the threat of a similar-style cold-boot attack.

Binaries
--------

YoNTMA is available for Mac, and has been tested on 10.9 and a little bit on 10.8.

* [YoNTMA (Mac) 0.9.9](https://github.com/iSECPartners/yontma-mac/releases/tag/0.9.9)
 * [dmg installer](https://github.com/iSECPartners/yontma-mac/releases/download/0.9.9/yontma-0.9.9.dmg) ([sig](https://github.com/iSECPartners/yontma-mac/releases/download/0.9.9/yontma-0.9.9.dmg.sig) [key](http://keyserver.ubuntu.com/pks/lookup?op=vindex&fingerprint=on&search=0xE578C0E157AD2E71))

[YoNTMA is also available for Windows](https://github.com/iSECPartners/yontma), in another Github project.

How to Run
----------
Open the .dmg file, and drag the application into your applications folder. Start the program, and a status bar icon will appear.

If you have not set the correct power management settings, it will prompt you to correct them. The application can do this if your provide your credentials, or you can do it yourself. If you do not have FileVault enabled, it will provide instructions for doing so.  

You can Enable/Disable the application by clicking the Status Bar icon. Right Clicking or Double-Clicking will let you change the preferences (including have it start at login), access debugging information, and exit the application.

Requirements
-------------

The machine must have FileVault enabled and have certain power management settings set. The application will prompt if it does not detect that these settings are set properly.

Build Instructions
------------------

YoNTMA builds in XCode and has no outside dependencies. 


Disclaimer
----------
iSEC has written this tool and provides it to the community free of charge. While iSEC has conducted testing of the tool on different systems, it has not been tested on all models, hardware, or configurations. The software is being provided "as is" without warranty or support. iSEC does not assume liability for any damage caused by use of this tool.

If you experience issues with YoNTMA, you can uninstall it by deleting it from your Applications folder. 