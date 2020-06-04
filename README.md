fixeep_82574_83: Intel EEPROM fix for 82574 and 82583 family NICs
=================================================================


Background
----------

Several adapters with the chipset display "TX unit hang" messages during
normal operation with the e1000e driver. The issue appears both with TSO
enabled and disabled and is caused by a power management function that is
enabled in the EEPROM. Early releases of the chipsets to vendors had the
EEPROM bit that enabled the feature. After the issue was discovered newer
adapters were released with the feature disabled in the EEPROM.

There exists a script to fix the EEPROM setting for existing machines
at the [e1000 project website](https://sourceforge.net/projects/e1000/files/e1000e%20stable/eeprom_fix_82574_or_82583/).

This salt-formula has the script slightly modified to make it work for more
operating systems that might not have ifconfig installed by default.
Furthermore the script has been adapted to support the [cmd.run stateful argument](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.cmd.html#using-the-stateful-argument).


Available states
----------------

``fixeep_82574_83``
^^^^^^^^^^^^^^^^^^^
Rewrite NIC eeprom to disable problematic power mode if needed

Available_pillars
-----------------

``fixeep_82574_83:reboot``
^^^^^^^^^^^^^^^^^^^^^^^^^^
The EEPROM change needs a reboot of the machine to take effect.

If the pillar is set to `true`, reboot the machine as part of the salt formula.
If the pillar is set to `false`, the machine is never rebooted as part of this role.

_Note: A reboot is a once only affair. On subsequent runs no EEPROM change happens, no reboot is needed either._
