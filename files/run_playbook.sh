## ad hoc command
# ansible [host or group] -m [module] -a "[module options]" -i [inventory file]
# ansible environment -m ping -i inventory.yaml 

function usage() {
    echo "Please, run this script with parameter like: -v , -vv , -vvv, -vvvv"
}

# declare an arrays from vagrant config file
array_ip=( $( cat ./for_vagrant/vagrant_config.yaml | \
    grep ip | awk -F ": " '{print $2}' | tr -d \" ) )

array_hosts=( $(cat ./for_vagrant/vagrant_config.yaml | \
    grep vagrant_name | awk -F ": " '{print $2}' | tr -d \") )

## Get length of array
hosts_count=${#array_hosts[@]}

function create_ansible_ini_inventory() {
    lines=( 
        '[local]' 
        'localhost ansible_connection=local' 
        ''
        '[internal_hosts:children]'
        'environment'
        ''
        '[environment:vars]'
        'ansible_user=vagrant'
        ''
        '[environment]')
    printf '%s\n' "${lines[@]}" > inventory.ini

    for ((i=0;i<hosts_count;i++)); do
        echo "${array_hosts[$i]} ansible_host=${array_ip[$i]}" \
            >> inventory.ini
    done
}

function convert_inventory_ini_to_yaml() {
    ansible-inventory -i inventory.ini --list --yaml \
        > inventory.yaml
    rm inventory.ini
}

verbose_level=$1

if [ $# -ne 0 ]; then # if number of arguments not equal zero
    re_verbose_level="^-v{1,4}$"
    # if parameter is not set correctly 
    if [[ ! $verbose_level =~ $re_verbose_level ]]; then 
        echo "Error: Parameter '$verbose' is not set correctly"
        usage
        exit 0
    fi
fi

mkdir -p commands_output_logs

(cd for_ansible/ && \
create_ansible_ini_inventory && \
convert_inventory_ini_to_yaml && \
ansible-playbook -i inventory.yaml --vault-pass-file vault -e '@vault.yml' playbook.yaml $1 ) \
| tee ./commands_output_logs/ansible-playbook_commands_output.log

(cd for_ansible/ && \
ansible-playbook -i inventory.yaml --vault-pass-file vault -e '@vault.yml' localhost_playbook.yaml $1 ) \
| tee -a ./commands_output_logs/ansible-playbook_commands_output.log

(cd for_vagrant/ && \
vagrant snapshot save --force ansible_provision ) \
| tee -a ./commands_output_logs/vagrant_commands_output.log
