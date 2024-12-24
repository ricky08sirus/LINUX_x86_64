cat packages.csv | while read line; do
  NAME="$(echo $line | cut -d\; -f1)"
  VERSION="$(echo $line | cut -d\; -f2)"
  URL="$(echo $line | cut -d\; -f3 | sed "s/@$VERSION/g")"
  MD5SUM="$(echo $line | cut -d\; -f4)"

  #from the url extract the name of the file which the system is downloading
  CACHEFILE="$(basename "$URL")"

  echo NAME $NAME
  echo VERSION $VERSION
  echo URL $URL
  echo MD5SUM $MD5SUM
  echo CACHEFILE $CACHEFILE
done
