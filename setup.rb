#!/usr/bin/env ruby

require 'io/console'
require 'pathname'
require 'fileutils'

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

def link_dotfile(source, dest)
  link_file("#{HERE}/#{source}", "#{HOME}/#{dest}")
end

def mkdir_ifne(dir)
  unless File.directory?(dir)
    Dir.mkdir_p(dir)
  end
end

def mkhomedir(dir)
  mkdir_ifne("#{HOME}/#{dir}")
end

def is_linux?
  RUBY_PLATFORM.match(/linux/) != nil
end

HOME = Dir.home
HERE = Dir.pwd

# Mutt
link_dotfile('mutt/muttrc', '.muttrc')

# SSH
mkhomedir('.ssh')
link_dotfile('ssh/config', '.ssh/config')

mkhomedir('bin')
link_dotfile('bin/ssh', 'bin/ssh')

if is_linux?
  # mpd
  mkhomedir('.mpd')
  link_dotfile('mpd/mpd', '.mpd/mpd.conf')

  # ncmpcpp
  mkhomedir('.ncmpcpp')
  link_dotfile('mpd/ncmpcpp', '.ncmpcpp/config')

  # Terminator
  mkhomedir('.config/terminator')
  link_dotfile('term/terminator', '.config/terminator/config')

  # xmonad
  mkhomedir('.xmonad')
  link_dotfile('xmonad/xmonad.hs', '.xmonad/xmonad.hs')
  link_dotfile('xmonad/startup.sh', 'bin/startup.sh')

  # xmobar
  link_dotfile('xmonad/xmobarrc', '.xmobarrc')
end
