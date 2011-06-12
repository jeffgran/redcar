
class RedcarGemspecHelper
  def self.remove_gitignored_files(filelist)
    ignores = File.readlines(".gitignore")
    ignores = ignores.select {|ignore| ignore.chomp.strip != "" and ignore !~ /^#/}
    ignores = ignores.map {|ignore| Regexp.new(ignore.chomp.gsub(".", "\\.").gsub("*", ".*"))}
    r = filelist.select {|fn| not ignores.any? {|ignore| fn =~ ignore }}
    r.select {|fn| fn !~ /\.git/ }
  end
  
  def self.remove_matching_files(list, string)
    list.reject {|entry| entry.include?(string)}
  end

  def self.gem_manifest
    r = %w(CHANGES LICENSE Rakefile README.md) +
                            Dir.glob("bin/redcar") +
                            Dir.glob("config/**/*") +
                            Dir.glob("share/**/*") +
                            remove_gitignored_files(Dir.glob("lib/**/*")) +
                            remove_matching_files(remove_gitignored_files(Dir.glob("plugins/**/*")), "redcar-bundles") +
                            Dir.glob("plugins/textmate/vendor/redcar-bundles/Bundles/*.tmbundle/Syntaxes/**/*") +
                            Dir.glob("plugins/textmate/vendor/redcar-bundles/Bundles/*.tmbundle/Preferences/**/*") +
                            Dir.glob("plugins/textmate/vendor/redcar-bundles/Bundles/*.tmbundle/Snippets/**/*") +
                            Dir.glob("plugins/textmate/vendor/redcar-bundles/Bundles/*.tmbundle/info.plist") +
                            Dir.glob("plugins/textmate/vendor/redcar-bundles/Themes/*.tmTheme")
    remove_matching_files(r, "multi-byte")
  end
end

Gem::Specification.new do |s|
  s.name        = "redcar-dev"
  s.version     = "0.12.3dev"
  s.platform    = "java"
  s.authors     = ["Daniel Lucraft"]
  s.email       = ["dan@fluentradical.com"]
  s.homepage    = "http://github.com/danlucraft/redcar"
  s.summary     = "A pure Ruby text editor"
  s.description = ""
 
  s.files        = RedcarGemspecHelper.gem_manifest
  s.executables  = ["redcar"]
  s.require_path = 'lib'
  s.extra_rdoc_files  = %w(README.md LICENSE CHANGES Rakefile)

  s.add_dependency("rubyzip")
  s.add_dependency("swt")
  s.add_dependency("lucene", "~> 0.5.0.beta.1")
  s.add_dependency("redcar-javamateview")
  s.add_dependency("bouncy-castle-java")
  s.add_dependency("plugin_manager")
  
  s.add_development_dependency("cucumber")
  s.add_development_dependency("rspec")
  s.add_development_dependency("watchr")
  
end