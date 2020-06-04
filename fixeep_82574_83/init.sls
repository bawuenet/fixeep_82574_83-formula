---
{#- Iterate over network interfaces and filter for actual devices #}
{%- for interface in salt['file.readdir']('/sys/class/net/')
        if salt['file.is_link']('/sys/class/net/' ~ interface ~ '/device')
        and salt['file.file_exists']('/sys/class/net/' ~ interface ~ '/device/vendor') %}
{#- Check PCI identifiers for potentially affected Intel devices
    Need to cut the last char, which is a newline before comparing #}
{%-   if salt['file.read']('/sys/class/net/' ~ interface ~ '/device/vendor')[:-1] == '0x8086' and
        salt['file.read']('/sys/class/net/' ~ interface ~ '/device/device')[:-1] in ('0x10d3', '0x10f6' '0x150c') %}
fixeep_script_{{ interface }}:
  cmd.script:
    - source: salt://fixeep_82574_83/files/fixeep-82574_83.sh
    - name: fixeep-82574_83.sh {{ interface }}
    - stateful:
      - test_name: fixeep-82574_83.sh {{ interface }} test
    - user: root
    - group: root
    - shell: /bin/bash
    - success_retcodes:
      - 2
{%-     if salt['pillar.get']('fixeep_82574_83:reboot', false) %}
    - watch_in:
      - module: fixeep_reboot
{%-     endif %}
{%-   endif %}
{% endfor %}

{%-     if salt['pillar.get']('fixeep_82574_83:reboot', false) %}
fixeep_reboot:
  module.wait:
     - system.reboot:
       - at_time: {{ salt['pillar.get']('fixeep_82574_83:reboot_delay', 1) }}
{%-     endif %}

