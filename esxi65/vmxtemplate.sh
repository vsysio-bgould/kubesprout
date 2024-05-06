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

TEMP=$(getopt -o ':' --long name:,numvcpu:,memsize:,network:,guestos:,out:,datastore:,stdout \
              -n 'vmxtemplate' -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

VMNAME=

while true; do
  case "$1" in
    --name ) VMNAME="$2"; shift 2 ;;
    --numvcpu ) NUMVCPU="$2"; shift 2 ;;
    --memsize ) MEMSIZE="$2"; shift 2 ;;
    --network ) VMNETWORK="$2"; shift 2 ;;
    --guestos ) GUESTOS="$2"; shift 2 ;;
    --datastore ) DATASTORE="$2"; shift 2 ;;
    --stdout ) STDOUTPUT="true"; shift 2 ;;
    --out ) OUT="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

if [[ -z "$GUESTOS" ]]; then
  GUESTOS="ubuntu-64"
fi

OUTPUT=""
VMDKFILE="$(echo /vmfs/volumes/$DATASTORE/$VMNAME/$VMNAME-converted.vmdk | sed -e 's/\//\\\//g')"
SWAPFILE="$(echo /vmfs/volumes/$DATASTORE/$VMNAME/$VMNAME.vswp | sed -e 's/\//\\\//g')"

# 00:50:56 - Range VMWare assigns for manual mac addresses
MACADDRESS="00:50:56:$(tr -dc A-F0-9 </dev/urandom | head -c 2; echo -n):$(tr -dc AF0-9 </dev/urandom | head -c 2; echo -n):$(tr -dc A-F0-9 </dev/urandom | head -c 2; echo -n)"
MACADDRESS=$(echo -n $MACADDRESS | tr '[:lower:]' '[:upper:]')

while IFS= read -r line;
do
  newline=$(echo $line | sed -e 's/!!VMNAME!!/'${VMNAME}'/g')
  newline=$(echo $newline | sed -e 's/!!NUMCPU!!/'${NUMVCPU}'/g')
  newline=$(echo $newline | sed -e 's/!!MEMSIZE!!/'${MEMSIZE}'/g')
  newline=$(echo $newline | sed -e 's/!!VMNETWORK!!/'${VMNETWORK}'/g')
  newline=$(echo $newline | sed -e 's/!!GUESTOS!!/'${GUESTOS}'/g')
  newline=$(echo $newline | sed -e 's/!!VMDKFILE!!/'${VMDKFILE}'/g')
  newline=$(echo $newline | sed -e 's/!!SWAPFILE!!/'${SWAPFILE}'/g')
  newline=$(echo $newline | sed -e 's/!!MACADDRESS!!/'${MACADDRESS}'/g')
  OUTPUT+=$(echo "$line\t\t\t\t\t\t\t\t-> $newline\n")
  if [[ "$STDOUTPUT" == "true" ]]; then
    printf "$newline\n"
  fi
done < "$(git rev-parse --show-toplevel)/esxi65/template.vmx"
