config-block:
  file.blockreplace:
    - name: C:\tap1\file.txt 
    - marker_start: "MARKER_START START etc_sudoers_system_name -TEXTDELETED-"
    - marker_end: "marker_end END etc_sudoers_system_name--"
    - content: |
        etc_sudoers_system_name
        file.blockreplace
        name: /etc/sudoers
        marker_start: "# START etc_sudoers_system_name -DO-NOT-EDIT-"
        marker_end: "# END etc_sudoers_system_name--"
        system_name ALL = NOPASSWD: /bin/systemctl restart apache2*
    - append_if_not_found: True
    - backup: '.bak'
    - show_changes: True
