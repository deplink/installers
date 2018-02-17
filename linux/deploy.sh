dir="$(cd "$(dirname "$0")" && pwd)"

# Get first argument (deplink version),
# or use default ("master") if not set.
tag=$1
version=$1
if [ -z "$version" ]; then
    tag=latest
    version=master
fi;

# Clone and build Deplink CLI
if [ ! -f "${dir}/artifacts/deplink-${tag}.phar" ]; then
	git clone https://github.com/deplink/deplink "${dir}/tmp"
	git -C "${dir}/tmp" checkout $version
	composer run-script build --working-dir "${dir}/tmp"

	mkdir -p "${dir}/deplink/usr/share/deplink/bin"
	cp "${dir}/tmp/bin/deplink.phar" "${dir}/deplink/usr/share/deplink/bin/deplink-${tag}.phar"

	mkdir -p "${dir}/deplink/usr/bin"
    echo 'php /usr/share/deplink/bin/deplink-${tag}.phar $@' > "${dir}/deplink/usr/bin/deplink"

    sed_find=Version: latest
    sed_replace=Version ${tag}
    sed -i -e 's/'"$sed_find"'/'"$sed_replace"'/g' "${dir}/deplink/DEBIAN/control"

	rm -rf "${dir}/tmp"
fi

# Build .deb package
dpkg-deb --build "${dir}/deplink"

# Register Travis CI key
eval "$(ssh-agent -s)"
mkdir -p ~/.ssh && chmod 700 ~/.ssh
echo "${TRAVIS_KEY64}" > ~/.ssh/travis_rsa64
base64 --decode ~/.ssh/travis_rsa64 > ~/.ssh/travis_rsa
chmod 600 ~/.ssh/travis_rsa
ssh-add ~/.ssh/travis_rsa

# Upload "build" directory to server
scp "${dir}/deplink.deb" "travis@deplink.org:/var/www/cdn.deplink.org/download/linux/deplink-${tag}.deb"
