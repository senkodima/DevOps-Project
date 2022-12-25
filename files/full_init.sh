#!/bin/bash

function run_docker_desktop {
    func_name="[ ${FUNCNAME[0]} ]:  "
    docker info >/dev/null 2>&1 || open -a Docker
    until docker info >/dev/null 2>&1
    do
        echo -e "$func_name Waiting for starting Docker Desktop ..."
        sleep 10
    done
    echo -e "$func_name Docker Desktop started"
}

function make_scripts_executable {
    SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
    chmod +x "$SCRIPT_DIR/init_run_vagrantfile.sh"
    chmod +x "$SCRIPT_DIR/run_playbook.sh"
    chmod +x "$SCRIPT_DIR/docker_compose_run.sh"
    chmod +x "$SCRIPT_DIR/back_to_vagrant_snapshot.sh"
}

function initial_setup {
    ./init_run_vagrantfile.sh && \
    ./run_playbook.sh && \
    run_docker_desktop && \
    ./docker_compose_run.sh
}

make_scripts_executable && \
initial_setup
