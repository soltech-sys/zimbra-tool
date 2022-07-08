#!/bin/bash
# rm_message.sh user@domain.com subject
# or
# rm_message.sh user@domain.com
# multimessage.sh email1@domain.com email2@domain.com email3-5@domain.com

if [ -z "$6" ]; then
addr=$1
for acct in `zmprov -l gaa | grep -E -v '(^admin@|^spam\..*@|^ham\..*@|^virus-quarantine.*@|^galsync.*@)'|sort` ; do
    echo "Searching $acct"    
    for addr in '$@'
    do
        for msg in `/opt/zimbra/bin/zmmailbox -z -m "$acct" s -l 999 -t message "from:$addr"|awk '{ if (NR!=1) {print}}' | grep -v -e Id -e "-" -e "^$" | awk '{ print $2 }'`
        do
                #echo "Removing "$msg" from "$acct""
                #/opt/zimbra/bin/zmmailbox -z -m $acct dm $msg
                echo "Moving "$msg" from "$acct" to Trash"
                /opt/zimbra/bin/zmmailbox -z -m $acct mm $msg /Trash
        done
    done
done
fi
