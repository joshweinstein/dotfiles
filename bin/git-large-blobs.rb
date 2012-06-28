#!/usr/bin/env ruby -w
# Usage:
# ruby ~/bin/dotfiles/bin/git-large-blobs.rb [BRANCH] [MINIMUM SIZE IN MEGABYTES]
#
# Ex:
# ruby ~/bin/dotfiles/bin/git-large-blobs.rb master 0.01
#
#
# Then, to remove large blobs that don't need to be in the repo or history,
# follow the steps below.
#
# http://stackoverflow.com/questions/2164581/remove-file-from-git-repository-history
#
#   1. check .git/packed-refs - my problem was that I had there a refs/remotes/origin/master line for a remote repository, delete it, otherwise git won't remove those files
#   2. (optional) git verify-pack -v .git/objects/pack/#{pack-name}.idx | sort -k 3 -n | tail -5 - to check for the largest files
#   3. (optional) git rev-list --objects --all | grep a0d770a97ff0fac0be1d777b32cc67fe69eb9a98 - to check what files those are
#   4. git filter-branch --index-filter 'git rm --cached --ignore-unmatch file_names'- to remove the file from all revisions
#   5. rm -rf .git/refs/original/ - to remove git's backup
#   6. git reflog expire --all --expire='0 days' - to expire all the loose objects
#   7. (optional) git fsck --full --unreachable - to check if there are any loose objects
#   8. git repack -A -d - repacking the pack
#   9. git prune - to finally remove those objects

head, treshold = ARGV
head ||= 'HEAD'
Megabyte = 1000 ** 2
treshold = (treshold || 0.1).to_f * Megabyte

big_files = {}

IO.popen("git rev-list #{head}", 'r') do |rev_list|
  rev_list.each_line do |commit|
    commit.chomp!
    for object in `git ls-tree -zrl #{commit}`.split("\0")
      bits, type, sha, size, path = object.split(/\s+/, 5)
      size = size.to_i
      big_files[sha] = [path, size, commit] if size >= treshold
    end
  end
end

big_files.each do |sha, (path, size, commit)|
  where = `git show -s #{commit} --format='%h: %cr'`.chomp
  puts "%4.1fM\t%s\t(%s)" % [size.to_f / Megabyte, path, where]
end
