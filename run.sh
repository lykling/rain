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

    chown -R 82:www-data /var/www/html
}

function launch {
    if [[ -f "/rainloop/.env.default"  ]]; then
        source /rainloop/.env.default
    fi
    if [[ ! -f /var/www/html/data/VERSION ]]; then
        mkdir -pv /var/www/html
        echo "Install rainloop $(cat /rainloop/rainloop/data/VERSION)"
        tar -zc -C /rainloop/rainloop . | tar -zx -C /var/www/html
    else
        c_ver="$(cat /var/www/html/data/VERSION)"
        n_ver="$(cat /rainloop/rainloop/data/VERSION)"
        s_ver="$(printf '%s\n' "${n_ver}" "${c_ver}" | sort -V | head -n1)"
        if [ "${s_ver}" = "${n_ver}" ]; then
            # New version little than or equal to current version
            :
        else
            # Upgrade
            echo "Upgrade rainloop to $(cat /rainloop/rainloop/data/VERSION)"
            tar -zc -C /rainloop/rainloop . | tar -zx -C /var/www/html
        fi
    fi
    fixpermission
    subenv /rainloop/nginx.conf.template /etc/nginx/conf.d/default.conf
    nginx -g "daemon off;"
}

function main {
    cmd=${1}
    shift
    "${cmd}" "$@"
}

main "$@"
