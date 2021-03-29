#!/bin/sh

function subenv {
    template="${1}"
    target="${2}"
    eval "
cat <<EOF
$(cat ${template})
EOF
" > ${target} 2> /dev/null
}

function launch {
    if [[ -f "/rainloop/.env.default"  ]]; then
        source /rainloop/.env.default
    fi
    subenv /rainloop/nginx.conf.template /etc/nginx/conf.d/default.conf
    nginx -g "daemon off;"
}

function main {
    cmd=${1}
    shift
    "${cmd}" "$@"
}

main "$@"
