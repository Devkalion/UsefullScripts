#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIR/.env"

prev_ip_file=prev_ip
prev_ip=$(cat ${prev_ip_file})
ip=$(curl 'https://api.my-ip.io/ip')
# ip=$(curl 'https://api.ipify.org')
# ip=$(echo $resp | python -m json.tool | grep ip | tr '"' '\n' | tail -n 2 | head -n 1)

if [ "${prev_ip}" != "${ip}" ] && [ "${ip}" != "" ]; then
    echo $(date)
    echo "New ip: ${ip}; Old ip: ${prev_ip}"

    resp=$(curl -X POST \
                -d "{\"recipient_id\":$recipient_id}" \
                -H 'Content-Type: application/json' \
                -H "Authorization: Bot $bot_token" \
                'https://discordapp.com/api/v6/users/@me/channels')

    echo "Client Channel Response:"
    echo $resp | python -m json.tool
    channel=$(echo $resp | python -m json.tool | grep '"id"' | head -n 1 | tr '"' '\n' | head -n 4 | tail -n 1)
    echo "Channel $channel"

    resp=$(curl -X POST \
                -d "{\"content\": \"$ip\"}" \
                -H 'Content-Type: application/json' \
                -H "Authorization: Bot $bot_token" \
                "https://discordapp.com/api/v6/channels/$channel/messages")

    echo "Send Message Response:"
    echo $resp | python -m json.tool
    echo "${ip}" > "$prev_ip_file"
fi
