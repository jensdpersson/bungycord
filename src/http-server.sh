#!/bin/sh -x
#
# Basic web server
#
# Much code here shamelessly translated from BaseHTTPServer.py
#

BC_HOME=${BC_HOME:-$(dirname $0)}

. ${BC_HOME}/bungycord.sh

bc_handle()
# Handle requests from a client
{
    local command path version 
    BC_CLOSE_CONNECTION=false

    while ! $BC_CLOSE_CONNECTION; do
	BC_CLOSE_CONNECTION=true
	read command path version
	if [ -z "$command" ]; then
	    break
	fi
	sfutil_info "Received request: $command $path $version"
	if [ -n "${version}" ]; then
            # >= HTTP/1.0
	    if [ "${version%/*}" != "HTTP" ]; then
		bc_send_error $command $STATUS_BAD_REQUEST "Bad request version ($version)"
		break
	    fi
	    local versionnr major minor
	    versionnr=${version#HTTP/}
	    major=${versionnr%.*}
	    minor=${versionnr#*.}
	    # Remove trailing \r
	    minor=$(echo "${minor}" | tr -d \\r)
	    if [ "$major" = 1 -a "$minor" -ge 1 ]; then
		BC_CLOSE_CONNECTION=false
	    fi
	    if [ "$major" -ge 2 ]; then
                bc_send_error $command $STATUS_HTTP_VERSION_NOT_SUPPORTED "Invalid HTTP Version ($versionnr)"
                break
	    fi
	elif [ -n "${path}" ]; then
	    # HTTP/0.9
	    true
	elif [ -n "${command}" ]; then
            bc_send_error $command $STATUS_BAD_REQUEST "Bad request syntax ($command)"
	    break
	fi

	# Parse headers
	bc_parse_headers

	# Check headers for 'Connection'
	case "$HEADER_CONNECTION" in
	    close)
		BC_CLOSE_CONNECTION=true ;;
	    keep-alive)
		BC_CLOSE_CONNECTION=false ;;
	esac

	# Remember request version
	export REQUEST_VERSION="${version}"

	# Dispatch request
	bc_handle_request $command $path
    done
}

bc_parse_headers()
{
    local headerTr=""
    while read -r; do
	REPLY=$(echo "${REPLY}" | tr -d \\r)
	local stripped=$REPLY
	if [ "$headerTr" != "" -a "$stripped" != "$REPLY" ]; then
	    # Handle multiline header
	    true
	fi
	if [ -z "$stripped" ]; then
	    break
	fi
	local header=${stripped%%:*}
	local value=${stripped#*:}
	headerTr=$(echo $header | tr [:lower:]- [:upper:]_)
	# Remember which headers we've seen
	HEADERS="$HEADERS $headerTr"
	eval HEADER_$headerTr=\'"$value"\'
	eval export HEADER_$headerTr
    done
}

bc_handle_request()
# Handle a single request from a client.
#
# Replace this function with a more sophisticated request handler!
#
# Parameters:
#   command
#   path
{
    local command="$1"; shift
    local path="$1"; shift

    sfutil_info "Performing $command on $path"
}

if [ $(basename $0) = 'http-server.sh' ]; then
    bc_handle
fi

