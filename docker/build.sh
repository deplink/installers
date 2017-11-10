# Get first argument (deplink version),
# or use default ("master") if not set.
tag=$1
version=$1
if [ -z "$version" ]; then
    tag=latest
    version=master
fi;

# Create Docker image
docker build https://github.com/deplink/deplink.git#$version -t deplink:$tag --rm
