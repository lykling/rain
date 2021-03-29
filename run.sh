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

function fixpermission {
    find /var/www/html -type d -exec chmod 755 {} \;
    find /var/www/html -type f -exec chmod 644 {} \;
}

function launch {
    if [[ -f "/rainloop/.env.default"  ]]; then
        source /rainloop/.env.default
    fi
    if [[ ! -f /var/www/html/data/VERSION ]]; then
        mkdir -pv /var/www/html
        tar -zc -C /rainloop/rainloop . | tar -zx -C /var/www/html
        fixpermission
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
