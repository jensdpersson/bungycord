#!/bin/bash
#
# Basic web server
#

BC_HOME=${BC_HOME:-$(dirname $0)}

. ${BC_HOME}/sfutil-base.subr
. ${BC_HOME}/response-codes.sh

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
{
    local close_connection command path version 
    close_connection=false

    while $close_connection; do
	close_connection=true
	read command path version
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
	    if [ "$major" = 1 -a "$minor" -ge 1 ]; then
		close_connection=false
	    fi
	    if [ "$major" -ge 2 ]; then
                bc_send_error $command $STATUS_HTTP_VERSION_NOT_SUPPORTED "Invalid HTTP Version ($versionnr)"
                break
	    fi
	elif [ -n "${path}" ]; then
	    # HTTP/0.9
	elif [ -n "${command}" ]; then
            bc_send_error $command $STATUS_BAD_REQUEST "Bad request syntax ($command)"
	    break
	fi

	# Parse headers

	# Check headers for 'Connection'
	# if 'close' => close_connection=true
	# if 'keep-alive' => close_connection=false
	
	# Dispatch request
    done
}
