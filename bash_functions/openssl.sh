function sslsiteinfo () {
  echo | openssl s_client -connect $1:443 -servername $1 2>/dev/null | openssl x509 -noout -dates -issuer -subject
}

function sslinfo () {
  openssl x509 -in $1 -noout -dates -issuer -subject
}

function sslinfofull () {
  openssl x509 -in $1 -noout -text
}

function sslsiteinfofull () {
  echo | openssl s_client -connect $1:443 -servername $1 2>/dev/null | openssl x509 -noout -text
}
