#!/bin/bash

tmp_dir="$(mktemp -d)"
tmp_file="${tmp_dir}/app.js"
elm make src/Main.elm --output "$tmp_file"
uglifyjs "$tmp_file" -o web/app.js --compress --mangle

rm "$tmp_file"
rmdir "$tmp_dir"
