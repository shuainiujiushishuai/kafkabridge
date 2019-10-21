#/usr/bin
make clean
make

rm -rf build_go
mkdir build_go

cd build_go
cmake -DCMAKE_BUILD_TYPE=Debug ../
make
cd ../

rm -rf ./examples/src
mkdir -p ./gopath/src/qbus
cp libQBus_go.so ./gopath/src/qbus
cp qbus.go ./gopath/src/qbus

while true; do
    echo -n "Use go module for examples? [Y/n]: "
    read ANSWER

    if [[ $ANSWER =~ ^[yYnN] ]]; then
        if [[ ${ANSWER:0:1} = [yY] ]]; then
            export GO111MODULE=on
            mkdir -p examples/qbus
            cp libQBus_go.so ./examples/qbus
            cp qbus.go ./examples/qbus

            cd examples && go mod init examples
            echo "
require qbus v1.0.0

replace qbus => ./qbus" >> go.mod
            cd qbus && go mod init qbus
        fi
        break
    else
        echo "[ERROR] invalid input: $ANSWER!"
    fi
done
