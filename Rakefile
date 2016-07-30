#
# Copyright (c) 2016-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree. An additional grant
# of patent rights can be found in the PATENTS file in the same directory.
#

carthage_archive_name = 'KVOController.framework.zip'
version_plist_path = File.join(File.dirname(__FILE__), 'FBKVOController', 'Info.plist')

desc 'Build release archive.'
task :archive do
  `rm -rf Carthage build`
  
  unless system('which carthage > /dev/null')
    abort 'Failed to find Carthage. Make sure it is installed first.'
  end
  
  puts 'Building release package.'
  unless system('carthage build --no-skip-current')
    abort 'Failed to build with Carthage.'
  end
  
  puts 'Archiving release package.'
  unless system('carthage archive')
    abort 'Failed to archive package'
  end
  
  system("mv #{carthage_archive_name} Carthage/")
  puts "Created release archive at Carthage/#{carthage_archive_name}"
end

desc 'Update version for next release.'
task :version, [:version] do |_, args|
  version = args[:version]
  if version.nil?
    return
  end
  
  require 'plist'
  
  info_plist = Plist.parse_xml(version_plist_path)
  info_plist['CFBundleShortVersionString'] = version
  info_plist['CFBundleVersion'] = version
  File.open(version_plist_path, 'w') { |f| f.write(info_plist.to_plist) }
end

desc 'Build and archive a release.'
task :release, [:version] => [:version, :archive]
