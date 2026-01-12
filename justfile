project_dir := justfile_directory()

# print available just recipes
[group('project-agnostic')]
default:
    @just --list --justfile {{justfile()}}

# evaluate and print all just variables
[group('project-agnostic')]
just-vars:
    @just --evaluate

# print system information such as OS and architecture
[group('project-agnostic')]
system-info:
    @echo "architecture: {{arch()}}"
    @echo "os: {{os()}}"
    @echo "os family: {{os_family()}}"

# build Linux binary with SDL2 support
[group('development')]
build-linux:
    @echo "== Installing Linux dependencies (Fedora) for SDL2 support"
    sudo dnf install -y SDL2_image-devel SDL2_mixer-devel SDL2_sound-devel SDL2_ttf-devel
    @echo "== Building Linux binary =="
    (cd src && make -f Makefile.std-sdl2 clean install) || exit 1
    @echo
    @echo "Run the 'faangband' binary in the top-level project folder."

# build native macOS app
[group('development')]
build-macos-app:
    # See docs/hacking/compiling.rst
    (cd src && make -f Makefile.osx clean install) || exit 1
    @echo
    @echo "Run the game via 'FAangband.app' in the top-level project folder"

# build console macOS binary with ncurses support
[group('development')]
build-macos-console:
    (cd src && make -f Makefile.osx-ncurses clean install) || exit 1
    @echo
    @echo "Run the 'faangband' binary in the top-level project folder."

# debug build native macOS app
[group('development')]
debug-build-macos-app:
    # See docs/hacking/compiling.rst
    (cd src && make -f Makefile.osx OPT="-g -O1 -fno-omit-frame-pointer -fsanitize=undefined -fsanitize=address" clean install) || exit 1
    @echo "Run the game (debug build) via 'FAangband.app' in the top-level project folder"

# debug build console macOS binary with ncurses support
[group('development')]
debug-build-macos-console:
    # See docs/hacking/compiling.rst
    (cd src && make -f Makefile.osx-ncurses OPT="-g -O1 -fno-omit-frame-pointer -fsanitize=undefined -fsanitize=address" clean install) || exit 1
    @echo "Run the game (debug build) via the 'faangband' binary in the top-level project folder."

# run FAangband as a native macOS app
[group('app')]
run-macos:
    open ./FAangband.app

# run FAangband as console binary (ASCII mode)
[group('app')]
run-console:
    # Options are explained at
    # https://github.com/angband/angband/blob/e723430/src/main-gcu.c#L1465-L1491
    ./faangband -mgcu -- -n6 -right "60x27,*" -bottom "*x12"

# run FAangband on Linux as console app (ASCII mode)
[group('app')]
run-linux-console: run-console

# run FAangband on Linux as SDL2 app
[group('app')]
run-linux-app:
    ./faangband -g -msdl2 -ssdl

# run FAangband as console macOS binary (ASCII mode)
[group('app')]
run-macos-console: run-console

# run FAangband as a native macOS app
[group('app')]
run-macos-app:
    open ./FAangband.app
