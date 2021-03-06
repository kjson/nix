source common.sh

clearStore

nix-instantiate --restrict-eval --eval -E '1 + 2'
(! nix-instantiate --restrict-eval ./simple.nix)
nix-instantiate --restrict-eval ./simple.nix -I src=.
nix-instantiate --restrict-eval ./simple.nix -I src1=simple.nix -I src2=config.nix -I src3=./simple.builder.sh

(! nix-instantiate --restrict-eval --eval -E 'builtins.readFile ./simple.nix')
nix-instantiate --restrict-eval --eval -E 'builtins.readFile ./simple.nix' -I src=..

(! nix-instantiate --restrict-eval --eval -E 'builtins.readDir ../src/boost')
nix-instantiate --restrict-eval --eval -E 'builtins.readDir ../src/boost' -I src=../src

(! nix-instantiate --restrict-eval --eval -E 'let __nixPath = [ { prefix = "foo"; path = ./.; } ]; in <foo>')
nix-instantiate --restrict-eval --eval -E 'let __nixPath = [ { prefix = "foo"; path = ./.; } ]; in <foo>' -I src=.

p=$(nix eval --raw "(builtins.fetchurl file://$(pwd)/restricted.sh)" --restrict-eval --allowed-uris "file://$(pwd)")
cmp $p restricted.sh

(! nix eval --raw "(builtins.fetchurl file://$(pwd)/restricted.sh)" --restrict-eval)

(! nix eval --raw "(builtins.fetchurl file://$(pwd)/restricted.sh)" --restrict-eval --allowed-uris "file://$(pwd)/restricted.sh/")

nix eval --raw "(builtins.fetchurl file://$(pwd)/restricted.sh)" --restrict-eval --allowed-uris "file://$(pwd)/restricted.sh"

(! nix eval --raw "(builtins.fetchurl https://github.com/NixOS/patchelf/archive/master.tar.gz)" --restrict-eval)
(! nix eval --raw "(builtins.fetchTarball https://github.com/NixOS/patchelf/archive/master.tar.gz)" --restrict-eval)
(! nix eval --raw "(fetchGit git://github.com/NixOS/patchelf.git)" --restrict-eval)
