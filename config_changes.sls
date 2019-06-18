{# {% set RNum = 'config/envconfig.jinja.' + pillar['RelNum'] %} #}

{% import_yaml 'config/AppMasterInfo.yaml' as app_master %}

{%- for app in pillar.get('AppList') %}
    {%- from 'config/' + app + '.envconfig.' + pillar['RelNum'] + '.jinja' import envconfig with context %}
    {%- for key, values in envconfig.items() %}
{%- for changes, settings in values.items() %}

{%- if key in app_master.appl_env %}
config_changes_{{ app  }}_{{ key }}_{{ changes }}:
  file.replace:
    - name: {{ settings.fname }}
    - pattern: {{ settings.pattern }}
    - repl: {{ settings.repl }} 
    - append_if_not_found: False 
    - show_changes: True
    - backup: .bak
    - ignore_if_missing: True
{%- endif %}
{%- endfor %}
    {%- endfor %}
{%- endfor %}
