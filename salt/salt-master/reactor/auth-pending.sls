{# Ink server faild to authenticate -- remove accepted key #}
{% if not data['result'] and data['id'].startswith('bootstrap') %}
minion_remove:
  wheel.key.delete:
    - match: {{ data['id'] }}
{% endif %}

{# Ink server is sending new key -- accept this key #}
{% if 'act' in data and data['act'] == 'pend' %}
minion_add:
  wheel.key.accept:
    - match: {{ data['id'] }}
sync_all:
  local.state.sls:
    - tgt: {{ data['id'] }}
    - arg: 
      - eonfabric_sync_all
{% endif %}
