{# {% from "config/AppMasterInfo.yaml" import appl_list with context %} #}
{% import_yaml 'config/AppMasterInfo.yaml' as app_master %}

{%- for appl in pillar.get('AppList') %}
copy_artifacts_{{ appl }}:
  file.recurse:
    - name: {{ app_master.target_location }}\{{ appl }} 
    - source: salt://artifacts/{{ appl }}
    - makedirs: True
    - replace: True
    - replaceTrue: True
    - include_empty: True
    - clean: False
{% endfor %}
 
