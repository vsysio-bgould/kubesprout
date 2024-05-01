#!/usr/bin/env bash

# VMX Parser
# This script writes a VMX file meant for use by ESXi.

# Prototype:
# ./vmxtemplate.sh -name <VM Name> -numvcpu <numCPUs> -memsize <MemorySize-in-MB>

#vmname=$1   # !!VMNAME!!
#numvcpu=$2  # !!NUMCPU!!
#memsize=$3  # !!MEMSIZE!!
#vmnetwork   # !!VMNETWORK!!
#guestos     # !!GUESTOS!!

TEMP=$(getopt -o ':' --long name:,numvcpu:,memsize:,network:,guestos: \
              -n 'vmxtemplate' -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

echo $TEMP
eval set -- "$TEMP"

VMNAME=

while true; do
  case "$1" in
    --name ) VMNAME="$2"; shift 2 ;;
    --numvcpu ) NUMVCPU="$2"; shift 2 ;;
    --memsize ) MEMSIZE="$2"; shift 2 ;;
    --network ) VMNETWORK="$2"; shift 2 ;;
    --guestos ) GUESTOS="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

if [[ -z "$GUESTOS" ]]; then
  GUESTOS="ubuntu-64"
fi

echo
echo Name: $VMNAME
echo VCPU: $NUMVCPU
echo MemorySize: $MEMSIZE
echo VMNetwork: $VMNETWORK
echo GUESTOS: $GUESTOS