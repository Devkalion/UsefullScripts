#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIR/.env"

# get dm channel id
resp=$(curl -X POST \
            -d "{\"recipient_id\": $recipient_id}" \
            -H 'Content-Type: application/json' \
            -H "Authorization: Bot $bot_token" \
            'https://discordapp.com/api/v6/users/@me/channels')

channel=$(echo $resp | python -m json.tool | grep '"id"' | head -n 1 | tr '"' '\n' | head -n 4 | tail -n 1)

# get messages
resp=$(curl -H 'Content-Type: application/json' \
            -H "Authorization: Bot $bot_token" \
            "https://discordapp.com/api/v6/channels/$channel/messages")

# get messages ids
message_ids=$(echo $resp | python -m json.tool | grep '"id"' | tr '"' '\n' | grep [0-9])

for id in $message_ids
do
    # delete message
    curl -X DELETE \
         -H 'Content-Type: application/json' \
         -H "Authorization: Bot $bot_token" \
         "https://discordapp.com/api/v6/channels/638487351366123530/messages/$id"
done
