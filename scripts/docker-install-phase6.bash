#!/usr/bin/env bash

set -e
set -o pipefail
set -x
pushd /tmp >/dev/null

export OPAMROOT=/opt/opam
export OPAMROOTISOK=1

# Aheui
git clone https://github.com/aheui/caheui.git
pushd caheui >/dev/null
make
mv aheui /usr/local/bin/
popd >/dev/null
rm -rf cahuei

# Battlestar
git clone https://github.com/xyproto/battlestar.git
pushd battlestar >/dev/null
make
mv cmd/battlestarc/battlestarc /usr/local/bin/
mv scripts/bts.sh /usr/local/bin/bts
popd >/dev/null
rm -rf battlestar

# Beatnik
git clone https://github.com/catseye/Beatnik.git
sed -i 's#env python#env python2#' Beatnik/script/beatnik.py
mv Beatnik/script/beatnik.py /usr/local/bin/beatnik
rm -rf Beatnik

# Binary Lambda Calculus
wget -nv https://www.ioccc.org/2012/tromp/tromp.c
clang tromp.c -Wno-everything -DInt=long -DX=8 -DA=500000 -o /usr/local/bin/tromp
rm tromp.c

# Cat
git clone https://github.com/cdiggins/cat-language.git /opt/cat
pushd /opt/cat >/dev/null
npm install
popd >/dev/null

# Clean
wget -nv "$(curl -sSL https://clean.cs.ru.nl/Download_Clean | grep linux/clean | grep -F 64.tar.gz | grep -Eo "https://[^>]+\.tar\.gz")"
mkdir /opt/clean
tar -xf clean*_64.tar.gz -C /opt/clean --strip-components=1
pushd /opt/clean >/dev/null
make
popd >/dev/null
ln -s /opt/clean/bin/clm /usr/local/bin/
rm clean*_64.tar.gz

sleep 2
find /opt/clean -name '*.o' -exec touch '{}' ';'

# Erlang
git clone https://github.com/erlang-ls/erlang_ls.git
pushd erlang_ls >/dev/null
make
mv _build/default/bin/erlang_ls /usr/local/bin/erlang_ls
popd >/dev/null
rm -rf erlang_ls

# Hexagony
git clone https://github.com/m-ender/hexagony.git /opt/hexagony

# Idris
wget -nv https://www.idris-lang.org/idris2-src/idris2-latest.tgz
tar -xf idris2-latest.tgz
make bootstrap-build SCHEME=chezscheme PREFIX=/usr/local
make install PREFIX=/usr/local
chmod -R a=u,go-w /usr/local/idris2-*
rm -rf Idris2-* idris2-latest.tgz

# Kalyn
git clone https://github.com/raxod502/kalyn.git
pushd kalyn >/dev/null
stack build kalyn
mv "$(stack exec which kalyn)" /usr/local/bin/kalyn
mkdir /opt/kalyn
mv src-kalyn/Stdlib src-kalyn/Stdlib.kalyn /opt/kalyn/
popd >/dev/null
rm -rf kalyn

# Lazy K
git clone https://github.com/irori/lazyk.git
pushd lazyk >/dev/null
make
mv lazyk /usr/local/bin/
popd >/dev/null
rm -rf lazyk

# Limbo
wget -nv "$(curl -sSL http://www.vitanuova.com/inferno/downloads.html | grep -E 'inferno-[0-9]+\.tgz' | grep -Eo 'http://[^"]+')"
tar -xf inferno-*.tgz -C /usr/local
pushd /usr/local/inferno >/dev/null
sed -i 's/gcc/gcc -m32/g' makemk.sh
./makemk.sh
PATH="$PWD/Linux/386/bin:$PATH" mk install
ln -s "$PWD/Linux/386/bin/emu" "$PWD/Linux/386/bin/limbo" /usr/local/bin/
popd >/dev/null
rm inferno-*.tgz

# LOLCODE
git clone https://github.com/justinmeza/lci.git
pushd lci >/dev/null
python3 install.py --prefix=/usr
popd >/dev/null
rm -rf lci

# Malbolge
git clone https://github.com/bipinu/malbolge.git
clang malbolge/malbolge.c -o /usr/local/bin/malbolge
rm -rf malbolge

# Oberon
file="$(curl -sSL https://miasap.se/obnc/ | grep -F obnc_ | grep -Eo 'obnc_[^"]+' | grep -v win | head -n1)"
wget -nv "https://miasap.se/obnc/downloads/${file}"
tar -xf obnc_*.tar.gz
pushd obnc-* >/dev/null
./build
./install
popd >/dev/null
rm -rf obnc_*.tar.gz obnc-*

# Ook
git clone https://git.code.sf.net/p/esco/code esco
pushd esco >/dev/null
autoreconf -fi
./configure --prefix="$PWD"
make
make install
mv bin/esco /usr/local/bin/
popd >/dev/null
rm -rf esco

# PAWN
git clone https://github.com/compuphase/pawn.git
pushd pawn >/dev/null
cmake .
make
mv pawncc pawnrun /usr/local/bin/
mkdir /opt/pawn
mv include /opt/pawn/
popd >/dev/null
rm -rf pawn

# Rapira
git clone https://github.com/freeduke33/rerap2.git
pushd rerap2 >/dev/null
make
mv rapira /usr/local/bin/rapira
popd >/dev/null
rm -rf rerap2

# Qalb
git clone https://github.com/nasser/---.git qalb
pushd qalb >/dev/null
mkdir -p /opt/qalb
mv public/qlb/*.js /opt/qalb/
popd >/dev/null
rm -rf qalb

# Slick
git clone https://github.com/kwshi/slick.git
pushd slick >/dev/null
opam switch create .
opam install --switch . $(dune external-lib-deps src --display=quiet | grep -F - | sed 's/- //; s/\..*//') -y
opam install --switch . menhir -y
opam exec --switch . dune build
mv _build/default/src/exe/main.exe /usr/local/bin/slick
popd >/dev/null
rm -rf slick

# Snobol
file="$(curl -sSL ftp://ftp.snobol4.org/snobol/ | grep -Eo 'snobol4-.*\.tar\.gz' | sort -rV | head -n1)"
wget -nv "ftp://ftp.snobol4.org/snobol/${file}"
tar -xf snobol4-*.tar.gz
rm snobol4-*.tar.gz
pushd snobol4-* >/dev/null
make || true
mv snobol4 /usr/local/bin/snobol4
popd >/dev/null
rm -rf snobol4-*

# Subleq
git clone https://github.com/davidar/subleq.git
pushd subleq/src >/dev/null
make sq
mv sq /usr/local/bin/
popd >/dev/null

# Tabloid
mkdir /opt/tabloid
pushd /opt/tabloid >/dev/null
wget -nv https://github.com/thesephist/tabloid/raw/master/static/js/lang.js
cat <<"EOF" >> lang.js
module.exports = { tokenize, Parser, Environment };
EOF
popd >/dev/null

# TECO
git clone https://github.com/blakemcbride/TECOC.git
pushd TECOC/src >/dev/null
make -f makefile.linux
mv tecoc /usr/local/bin/tecoc
ln -s /usr/local/bin/tecoc /usr/local/bin/teco
ln -s /usr/local/bin/tecoc /usr/local/bin/mung
popd >/dev/null
rm -rf TECOC

# Thue
wget -nv "$(curl -sSL https://catseye.tc/distribution/Thue_distribution | grep -Eo 'https://catseye.tc/distfiles/thue-[^"]+\.zip' | head -n1)"
unzip thue-*.zip
rm thue-*.zip
pushd thue-* >/dev/null
./build.sh
mv bin/thue /usr/local/bin/thue
popd >/dev/null
rm -rf thue-*

# Velato
wget -nv http://www.archduke.org/midi/asc2mid.c
clang asc2mid.c -o /usr/local/bin/asc2mid
rm asc2mid.c

# Zot
git clone https://github.com/manyoso/zot.git
pushd zot >/dev/null
./build.sh
mv build/bin/zot /usr/local/bin/zot
popd >/dev/null
rm -rf zot

popd >/dev/null
rm "$0"
