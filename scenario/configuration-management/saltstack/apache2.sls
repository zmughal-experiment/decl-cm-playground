apache2:
  pkg.installed:
    - name: apache2
  #service.running:
  #  - name: apache2
  #  - enable: True

check_apache_version:
  cmd.run:
    - name: apache2ctl -v
    - require:
      - pkg: apache2
