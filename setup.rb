#!/usr/bin/env ruby

require 'io/console'
require 'pathname'

def confirm_delete(dest, msg = "Delete #{dest}?")
  print "#{msg} [y/N] "

  char = STDIN.getch
  print "#{char}\n"

  unless char.match(/y/)
    return false
  end

  if File.directory?(dest)
    File.rmdir(dest)
  else
    File.delete(dest)
  end
end

def link_file(source, dest)
  if File.exists?(dest)
    if Pathname.new(dest).realpath == Pathname.new(source).realpath
      puts "Link #{source} => #{dest} already exists; skipping..."
      return true
    else
      confirm_delete(dest, "File #{dest} exits, replace?")
    end
  elsif File.symlink?(dest)
    # Broken symlink
    confirm_delete(dest, "Symlink #{dest} already exists, but is broken, replace?")
  end

  File.symlink(source, dest) == 0
end

def mkdir_ifne(dir)
  unless File.directory?(dir)
    Dir.mkdir(dir)
  end
end

HOME = Dir.home
HERE = Dir.pwd

# Mutt
link_file("#{HERE}/mutt/muttrc", "#{HOME}/.muttrc")

# SSH
mkdir_ifne("#{HOME}/.ssh")
link_file("#{HERE}/ssh/config", "#{HOME}/.ssh/config")

mkdir_ifne("#{HOME}/bin")
link_file("#{HERE}/bin/ssh", "#{HOME}/bin/ssh")
