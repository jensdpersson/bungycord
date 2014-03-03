#!/bin/sh

cat <<EOF
<head>
<title>Error response</title>
</head>
<body>
<h1>Error response</h1>
<p>Error code ${code}.
<p>Message: ${message}.
<p>Error code explanation: ${code} = ${explain}.
</body>
EOF
