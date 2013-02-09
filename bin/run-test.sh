if [ ! -p test-commands ]; then
    mkfifo test-commands
fi

while true; do
    sh -c "$(cat test-commands)"
done
