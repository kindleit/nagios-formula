=============
nagios & nrpe
=============

Formulas to set up and configure nagios server and nrpe agent

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/topics/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``nagios``
----------

Installs the nagios and nrpe package and start the services


``nagios.server``
----------

Install the nagios package and start the nagios service.


``nagios.nrpe``
----------

Installs the nrpe agent and start the service


Example Pillar:

.. code:: yaml
  # Nagios Pillar
  # server: <IP/FQDN of main nagios server>
  # users:
  #   <username>:
  #     password: <Password>
  # permissions:
  #   autorized_for_system_information: ['user1','user2']
  #   ...
  #   authorized_for_all_host_commands: ['user1','user2']
  # groups:
  #   <nameofgroup>:
  #     members: <['minion1', 'minion2']>
  #     description: <Descripon of service>
  #     cmd: <Nagios command>
  nagios:
    server: nagios.example.com
    users:
      nadmin:
        password: Notreal
      dgarcia:
        password: Notreal
    permissions:
      authorized_for_system_information: ['nagiosadmin']
      authorized_for_configuration_information: ['nagiosadmin']
      authorized_for_system_commands: ['nagiosadmin']
      authorized_for_all_services: ['nagiosadmin']
      authorized_for_all_hosts: ['nagiosadmin']
      authorized_for_all_service_commands: ['nagiosadmin']
      authorized_for_all_host_commands: ['nagiosadmin']
    groups:
      ssh:  
        members: ['srv1', 'srv2', 'srv3']
        description: 'SSH Service'
        cmd: check_ssh
        service_template: generic-service
      http: 
        members: ['srv1', 'srv2', 'srv3']
        description: 'HTTP Service'
        cmd: check_http
        service_template: generic-service

