#!/bin/bash

## COLORS
NC="\033[0m" # No Color
YELLOW="\033[1;33m"      # '1;' - for bold, '0;' - for default 
LIGHT_RED="\033[1;91m"   # '1;' - for bold, '0;' - for default 
LIGHT_GREEN="\033[1;32m" # '1;' - for bold, '0;' - for default 

echo -n "Wait a second ..."

function print_error() {
    echo -e "$LIGHT_RED"
    echo "!!! Error !!!"
    echo "Wrong snapshot number"
    echo "Vagrant snapshot restore skipped"
    echo -e "$NC"
}

vagrant_snapshot_list=$(cd for_vagrant/ && vagrant snapshot list)

if (echo "${vagrant_snapshot_list}" | \
    grep -q 'vagrant snapshot save'); then
    echo -e "\r!!! No one vagrant snapshot exists !!!"
    exit 0
fi

vagrant_snapshots=( $( \
    echo "${vagrant_snapshot_list}" | \
    grep -v '==>' | \
    sort --unique) )

i=1
echo -e "\rSelect vagrant snapshot to restore:"
for snapshot in "${vagrant_snapshots[@]}"
do
    echo "(${i}) ${snapshot}"
    i=$((i+1))
done
echo "(0) 'Exit this script'"

echo ""
read -p "$(echo -e $YELLOW"Your choice: "$NC)" snapshot_number

# Check if not a number
if ! [[ $snapshot_number =~ ^[0-9]+$ ]]; then
   print_error
   exit 0
fi
## -eq # equals 0
if [[ "$snapshot_number" -eq 0 ]]; then
    exit 0
fi

snapshot_number=$((snapshot_number-1))
selected_snapshot_name="${vagrant_snapshots[snapshot_number]}"

TIMEFORMAT="  ***** ELAPSED TIME: %0lR *****  "
time {
if [[ -z "${selected_snapshot_name}" ]]; then
    print_error
else
    echo ""
    echo -e "${LIGHT_GREEN}Back all machines to '${selected_snapshot_name}' snapshot${NC}"
    cd for_vagrant/ && \
    vagrant snapshot restore $selected_snapshot_name
fi
}
