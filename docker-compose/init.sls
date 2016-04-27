{% set settings = salt['pillar.get']('docker-compose:lookup:settings', {}) %}

sources_list_docker:
  pkgrepo.managed:
    - humanname: docker packages
    - name: deb deb https://apt.dockerproject.org/repo debian-{{ settings.get('dist', 'jessie') }} main
    - file: /etc/apt/sources.list.d/docker.list
    - keyid: 58118E89F3A912897C070ADBF76221572C52609D
    - keyserver: p80.pool.sks-keyservers.net
    - require_in:
      - pkg: docker_packages

docker_packages:
  pkg.installed:
    - pkgs:
      - docker-engine
      - docker-compose

docker_service:
  service.running:
    - name: docker
    - enable: True
    - require:
      - pkg: docker_packages
    - watch:
      - pkg: docker_packages
