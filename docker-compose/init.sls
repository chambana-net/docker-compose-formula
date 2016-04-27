{% set settings = salt['pillar.get']('docker-compose:lookup:settings', {}) %}
{% set compose_version = "1.7.0" -%}


sources_list_docker:
  pkgrepo.managed:
    - humanname: docker packages
    - name: deb https://apt.dockerproject.org/repo debian-{{ settings.get('dist', 'jessie') }} main
    - file: /etc/apt/sources.list.d/docker.list
    - keyid: 58118E89F3A912897C070ADBF76221572C52609D
    - keyserver: p80.pool.sks-keyservers.net
    - require_in:
      - pkg: docker_package

docker_package:
  pkg.installed:
    - pkgs:
      - docker-engine

compose_install:
  file.managed:
    - name: /usr/local/bin/docker-compose
    - source: https://github.com/docker/compose/releases/download/{{ compose_version }}/docker-compose-Linux-x86_64
    - source_hash: sha1=a2ea90beed70dd56f7f42f2a8b442b9a6790ddb2
    - user: root
    - group: root
    - mode: 0755
    - force: True

docker_service:
  service.running:
    - name: docker
    - enable: True
    - require:
      - pkg: docker_package
    - watch:
      - pkg: docker_package
