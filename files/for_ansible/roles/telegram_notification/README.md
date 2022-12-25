Role Name
=========

A simple Ansible Role that send telegram notification.

Requirements
------------

None.

Role Variables
--------------

Variables that are used in role:

    telegram_token: '9999999:XXXXXXXXXXXXXXXXXXXXXXX'
    telegram_chat_id: '0000000000'

Dependencies
------------

None.

Example Playbook
----------------

```yaml
- name: Run full playbook
  hosts: all
  tasks:
    - name: Start running Telegram notify
      ansible.builtin.include_role:
        name: telegram_notification
      vars:
        status: run
        
    - name: Success Telegram notify
      ansible.builtin.include_role:
        name: telegram_notification
      vars:
        status: success

    - name: Success Telegram notify
      ansible.builtin.include_role:
        name: telegram_notification
        tasks_from: success
        
    - name: Failure Telegram notify
      ansible.builtin.include_role:
        name: telegram_notification
      vars:
        status: failure

    - name: Failure Telegram notify
      ansible.builtin.include_role:
        name: telegram_notification
        tasks_from: failure          
```

License
-------

MIT / BSD

Author Information
------------------

Dmitry Senko
