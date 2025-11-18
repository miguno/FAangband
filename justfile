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

# build with Makefile.osx
[group('development')]
build-macos:
    # See docs/hacking/compiling.rst
    (cd src && make -f Makefile.osx clean install) || exit 1
    @echo "Run the game via 'FAangband.app' in the top-level project folder"

# debug build with Makefile.cocoa
[group('development')]
debug-build-macos:
    # See docs/hacking/compiling.rst
    (cd src && make -f Makefile.osx OPT="-g -O1 -fno-omit-frame-pointer -fsanitize=undefined -fsanitize=address" clean install) || exit 1
    @echo "Run the game (debug build) via 'Sil.app' in the top-level project folder"

# run FAangband as a native macOS app
[group('app')]
run-macos:
    open ./FAangband.app
