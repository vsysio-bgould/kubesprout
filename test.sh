
#        BUFFER="Hostname\tNetwork\tMAC\n"
#        while IFS="" read -r hostname module numcpu memsize network mac
#        do
#          if [[ "$hostname" != "Hostname" ]]; then
#            BUFFER+="${hostname}"
#            BUFFER+="${network}"
#            BUFFER+="${mac}"
#            BUFFER+="\n\n\n\n\n\n\n\n\n\n\n\n"
#            echo host - $hostname
#            echo network - $network
#            echo mac - $mac
#          fi
#        done < "./hosts/hosts.txt"
        #echo $BUFFER
        unset BUFFER

        BUFFER="VM Name\tHostname\tNetwork\tMAC\n"
        declare -a line
        while read -rs -aline
        do
          if [[ "${line[0]}" != "Hostname" ]]; then
            BUFFER+="${line[0]}\t${line[0]}.vmnet.arpa\t${line[4]}\t${line[5]}\n"
          fi
        done < "./hosts/hosts.txt"

        echo -e $BUFFER | column -t