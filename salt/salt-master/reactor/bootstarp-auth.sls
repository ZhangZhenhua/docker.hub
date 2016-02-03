{# Ink server faild to authenticate -- remove accepted key #}
{% if not data['result'] and data['id'].startswith('bootstrap') %}
minion_remove:
  wheel.key.delete:
    - match: {{ data['id'] }}
{% endif %}

{# Ink server is sending new key -- accept this key #}
{% if 'act' in data and data['act'] == 'pend' and data['id'].startswith('bootstrap') %}
minion_add:
  wheel.key.accept:
    - match: {{ data['id'] }}
{% endif %}
