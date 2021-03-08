#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo "[1/6] Activating venv"

if [[ ! -f venv/bin/activate ]]; then
    python -m venv venv
fi

source venv/bin/activate

echo "[2/6] Cleaning cache"
rm -rf build
rm -rf es-bootstrap-lambda.zip

echo "[3/6] Creating local copy"
mkdir -p build
cp lambda/*.py build/
cp lambda/requirements.txt build/

echo "[4/6] pip install"
cd build
docker run --rm -v $(pwd):/root/p python:3.7 pip3 install -r /root/p/requirements.txt -t /root/p/ > /dev/null

echo "[5/6] Compiling and making zip package"
python -m compileall .
zip -r9 ../es-bootstrap-lambda.zip ./ -x ".*" > /dev/null
cd ..

echo "[6/6] Tearing down venv"
deactivate
rm -rf venv

echo "Finished!"