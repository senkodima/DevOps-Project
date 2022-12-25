#!/bin/bash

while :; do
    case $1 in
        -s|--start)
            cd jenkins/ && \
            docker compose up -d
            echo "docker compose is up"
            exit
            ;;
        -d|--down)
            cd jenkins/ && \
            docker compose down
            echo "docker compose is down"
            exit
            ;;
        -r|--remove)
            cd jenkins/ && \
            docker compose down && \
            echo "volume '$(docker volume rm jenkins_agent_jenkins)' removed" && \
            echo "volume '$(docker volume rm jenkins_agent_agent)'   removed"
            echo "docker compose is down"
            exit
            ;;
        --)  # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            printf 'Running default case\n\n' >&2
            ;;
        *)  # Default case: No more options, so break out of the loop.
            cd jenkins/ && \
            docker compose down && \
            echo "volume '$(docker volume rm jenkins_agent_jenkins)' removed" && \
            echo "volume '$(docker volume rm jenkins_agent_agent)'   removed" && \
            docker compose up -d
            break
    esac
    shift
done