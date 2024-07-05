#!/bin/bash -euo

echo "Starting build process..."

mkdir -p $PREFIX/bin

# install ijulia
echo "Installing IJuLia"
julia -e 'using Pkg; Pkg.add("IJulia"); Pkg.build(); using IJulia;'

# download the latest baysor release
echo "Adding Package Baysor..... "
julia -e 'using Pkg; Pkg.add(PackageSpec(url="https://github.com/kharchenkolab/Baysor.git"));'

# build baysor
echo "Building Package Baysor..."
export LazyModules_lazyload=false
julia -e 'import Baysor, Pkg; Pkg.activate(dirname(dirname(pathof(Baysor)))); Pkg.instantiate(); Pkg.build();'
unset LazyModules_lazyload
echo "Build process completed."

# copy over the executable
cp $BUILD_PREFIX/share/julia/bin/baysor $PREFIX/bin
chmod a+x $PREFIX/bin/baysor
