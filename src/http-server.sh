#!/bin/sh -x
#
# Basic web server
#
# Much code here shamelessly translated from BaseHTTPServer.py
#

BC_HOME=${BC_HOME:-$(dirname $0)}
BC_LOG=${BC_LOG:-${BC_HOME}/../bungycord.log}

. ${BC_HOME}/sfutil-base.subr
. ${BC_HOME}/response-codes.sh

exec 3>> $BC_LOG

bc_quote_html()
{
    echo $1 | sed -e 's/&/&amp;/g' -e 's/</&lt;/g' -e 's/>/&gt;/g'
}

bc_status_message()
# Get text message for given status code
{
    eval 'echo $RESPONSE_SHORT_'$1
}

bc_status_explain()
# Get text message for given status code
{
    eval 'echo $RESPONSE_LONG_'$1
}

bc_send_error()
# Send error response to server
#
# Parameters:
#   command
#   status code
#   error message
{
    local command status message content_type explain
    command="$1"; shift
    status="$1"; shift
    message="${1:-$(bc_status_message $status)}"; shift
    content_type="${1:text/html}"; shift
    bc_send_response $status "$message"
    bc_send_header 'Content-Type' $content_type
    bc_send_header 'Connection' 'close'
    bc_end_headers
    
    if [ "$command" != 'HEAD' -a "$status" -ge 200 -a "$status" != 204 -a "$status" != 304 ]; then
	explain=$(bc_status_explain $status)
	message=$(bc_quote_html $message)
	. ${BC_HOME}/templates/error.html.sh
    fi

}

bc_handle()
# Handle requests from a client
{
    local close_connection command path version 
    close_connection=false

    while ! $close_connection; do
	close_connection=true
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
		close_connection=false
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
		close_connection=true ;;
	    keep-alive)
		close_connection=false ;;
	esac
	
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


bc_handle
