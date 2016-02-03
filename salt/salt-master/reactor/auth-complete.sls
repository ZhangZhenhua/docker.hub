sync_all:
  local.state.sls:
    - tgt: {{ data['id'] }}
    - arg: 
      - eonfabric_sync_all
