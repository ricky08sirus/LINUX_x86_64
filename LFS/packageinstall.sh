# Set error handling
set -e
CHAPTER=$1
PACKAGE=$2
cat packages.csv | grep -i "^$PACKAGE" | grep -i -v "\.patch;" | while read line; do
  #NAME="$(echo "$line" | cut -d\; -f1)"
  VERSION="$(echo "$line" | cut -d\; -f2)"
  URL="$(echo "$line" | cut -d\; -f3 | sed "s/@/$VERSION/g")"
  #MD5SUM="$(echo "$line" | cut -d\; -f4)"
  CACHEFILE="$(basename "$URL")"

  #extact the CACHEFILE
  DIRNAME="$(echo "$CACHEFILE" | sed "s/\(.*\)\.tar\../\1/")"

  #.* recognize anything in the start of the filename
  #(.*\) this will capture in  a capture group
  mkdir -pv "DIRNAME"
  echo "extacting $CACHEFILE"
  tar -xf "$CACHEFILE" -C "$DIRNAME"
  pushd "$DIRNAME"
  if [ "$(ls -1A | wc -1)" == "1" ]; then
    mv $(ls -1A)/* ./

  fi
  #run the scipt from the directory

  echo "Compiling $PACKAGE"
  sleep 5
  source "../chapter$CHAPTER/$PACKAGE.sh"
  echo "Done Compiling $PACKAGE"
  popd

done
