{% from 'APP2/config/JGCommon.win_services.' + pillar['RelNum'] + '.jinja' import config with context %}
{% set solutionConfig = config.details %}
{% set websiteRoot = "C:\\inetpub\\wwwroot" %}

#Install Server Manager features (IIS)

install_ServerManager_features:
  win_servermanager.installed:
   - recurse: True
   - features:
   {% for feature in solutionConfig.features_to_install %}
     - {{ feature }}
   {% endfor %}

{% for name in solutionConfig.binding %}
{% for config in solutionConfig.iis_config %}

#Create Directories
{{ websiteRoot}}\{{ config.appname }}:
  file.directory

#Create https binding

{{ config.appname }}-https-binding:
    win_iis.create_binding:
      - site: {{ config.sitename }}
      - hostheader: {{ name.hostname }}
      - protocol: {{ name.protocol }}

#Create_cert_binding


{{ config.appname}}-cert-binding:
    win_iis.create_cert_binding:
       - name: {{ name.cert_name }}
       - site: {{ config.sitename }}

#Create_appool

{{ config.appname }}-apppool:
    win_iis.create_apppool:
        - name: {{ config.apppoolname }}

#Create_application

{{ config.sitename }}-{{ config.appname }}-app:
  win_iis.create_app:
    - name: {{ config.appname }}
    - site: {{ config.sitename }}
    - sourcepath: {{ websiteRoot}}\{{ config.appname }}
    - apppool: {{ config.apppoolname }}

#Apppool_Container_settings
{{ config.apppoolname }}_container_settings:
  win_iis.container_setting:
      - name: {{ config.apppoolname }}
      - container: {{ config.container }}
      - settings:
          managedPipelineMode: {{ config.managedPipelineMode }}
          ManagedRuntimeVersion: {{ config.ManagedRuntimeVersion }}
          enable32BitAppOnWin64: {{ config.enable32BitAppOnWin64 }}
          processModel.idleTimeout: {{ config.processModel_idleTimeout }}
          recycling.periodicRestart.time: {{ config.recycling_periodicRestart_time }}
          processModel.userName: {{ config.processModel_username }}
          processModel.password: {{ config.processModel_password }}

#Configure Application Security
#This state needs to be updated after Saltstack updates the win_iis module in the next release.

{% for auth in solutionConfig.authentication_types %}
{{ config.appname }}-{{auth.name}}:
  cmd.run:
    - name: appcmd.exe set config "{{ config.sitename }}" -section:system.webServer/security/authentication/{{ auth.name }} /enabled:"{{ auth.enabled }}" /commit:apphost
    - cwd: c:\Windows\System32\inetsrv
{% endfor %}

{% endfor %}

{% endfor %}

