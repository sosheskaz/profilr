#!/bin/sh -ex

version=$1
text=$2
branch=$(git rev-parse --abbrev-ref HEAD)
repo_full_name=$(git config --get remote.origin.url | sed 's/.*:\/\/github.com\///;s/.git$//')
token=$(git config --global github.token)

generate_post_data()
{
  cat <<EOF
{
  "tag_name": "$version",
  "target_commitish": "$branch",
  "name": "$version",
  "body": "$text",
  "draft": false,
  "prerelease": false
}
EOF
}

echo "Create release $version for repo: $repo_full_name branch: $branch"
curl --data "$(generate_post_data)" "https://api.github.com/repos/$repo_full_name/releases?access_token=$token" || true

release_info=$(curl "https://api.github.com/repos/$repo_full_name/releases/tags/$version?access_token=$token")

release_id=$(echo "$release_info" | jq -r .id)

for osdir in dist/* ; do
  os=$(basename $osdir)
  for archdir in $osdir/* ; do
    arch=$(basename $archdir)
    xz -zc $archdir/profilr > "profilr-$os-$arch.xz"
    curl --data-binary "@profilr-$os-$arch.xz" -H "Authorization: token $token" -H "Content-Type: application/octet-stream" "https://uploads.github.com/repos/$repo_full_name/releases/$release_id/assets?name=profilr-$os-$arch.xz"
  done
done

rm profilr*.xz
