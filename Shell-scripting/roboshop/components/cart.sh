echo cart component

a="test1"

if [ "$a" == "perfect" ] || [ "$a" == "test1" ]; then
    echo "well done or condition "
elif [ "$a" == "test" ] ; then
    echo "else if block"
else
  echo "final block"
fi