
{% from "config/dotnet4.jinja" import dotnet4 with context %}

{%- if dotnet4.hotfix_os %}
{#- For win8 or later, or ws2012 or later, use the pkg *module* to inl .NET. #}
dotnet:
  module.run:
    - name: pkg.install
    - m_name: dotnet
    - kwargs:
        m_version: {{ dotnet4.version }}
    - onlyif: 'powershell.exe -noprofile -command
        "if (@({{ dotnet4.hotfix_ids | map('tojson') | join(',') | replace('"','\\"') }}) |? { @((get-wmiobject -class win32_quickfixengineeriHotFixID) -contains $_ }) {
            echo \".NET {{ dotnet4.version }} or greater already instd\"; exit 1
        }"
    '
{%- else %}
{#- For every other Windows version, use the pkg state to install the specified
    version of .NET. #}
dotnet4:
  pkg.installed:
    - name: 'dotnet'
    - version: {{ dotnet4.version }}
    - allow_updates: True

{%- endif %}


