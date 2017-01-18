#!/usr/bin/env bash
set -e
set -x # Uncomment to debug

KEY_NAME=do-meetup

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${MY_DIR}"

eval $(sed -e 's|^|export TF_VAR_|g' .env)

if [ -z "${TF_VAR_do_token}" ]; then
    echo "Ensure either TF_VAR_do_token variable is set or you have do_token in your .env file in the folder ${MY_DIR}"
    exit 1
fi

if [ -z "${TF_VAR_pvt_key}" ] || [ -z "${TF_VAR_pub_key}" ]; then
    KEYS_FOLDER="${MY_DIR}/keys"
    KEY_PATH="${KEYS_FOLDER}/${KEY_NAME}"
    mkdir -p "${KEYS_FOLDER}"
    if [[ ! -f "${KEY_PATH}" ]]; then
        ssh-keygen -t rsa -f "${KEY_PATH}" -N "" -q
    fi
    export TF_VAR_pvt_key="${KEY_PATH}"
    export TF_VAR_pub_key="${KEY_PATH}.pub"
fi

if [ -z "${TF_VAR_ssh_fingerprint}"]; then
    export TF_VAR_ssh_fingerprint=$(ssh-keygen -E md5 -lf ${TF_VAR_pvt_key} | awk '{print $2}' | sed 's|^MD5:||g')
fi

curl -X GET \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${TF_VAR_do_token}" \
    "https://api.digitalocean.com/v2/account/keys/${TF_VAR_ssh_fingerprint}" || \
    curl -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${TF_VAR_do_token}" \
    -d "{\"name\":\"${KEY_NAME}\",\"public_key\":\"$(cat "${TF_VAR_pub_key}")\"}" \
    "https://api.digitalocean.com/v2/account/keys"

ACTION=$@
if [ -z "${ACTION}" ]; then
    ACTION="apply"
fi

terraform ${ACTION}
