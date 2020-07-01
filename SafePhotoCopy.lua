#!/usr/bin/env lua

-- Please be aware that this script needs the luafilesystem (lfs)
-- library to run.  This may be available as a package; if not, it
-- is available at https://github.com/keplerproject/luafilesystem

-- BSD 2-Clause License

-- Copyright (c) 2019, 2020 Sam Trenholme
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:

-- 1. Redistributions of source code must retain the above copyright notice, 
--    this list of conditions and the following disclaimer.

-- 2. Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
-- "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
-- LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
-- A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
-- HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-- SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
-- TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
-- PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-- LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-- Usage: ./SafePhotoCopy.lua $SOURCE $DEST
-- Here, SOURCE is the directory we get photos from
-- DEST is the directory we put photos in
-- Example:
-- ./SafePhotoCopy.lua /media/SDCARD/DCIM/ /home/name/Photos/Camera/

if not lfs then lfs = require "lfs" end
if not lfs then print "lfs library needed" os.exit(1) end

-------------------------- fileCopy() --------------------------
-- copy a file at location "source" to "destination"
-- If "b" is already present then fail
-- Fail if read or write do not work
-- Return true or false; if return false, also return error string
function fileCopy(source, destination)
  if lfs.attributes(destination) then
    return false, "filecopy will not overwrite " .. destination
  end
  i = io.open(source, "rb")
  if not i then return false, "could not open " .. source end
  o = io.open(destination, "wb")
  if not o then
    i:close()
    return false, "could not write to " .. destination 
  end
  buffer = i:read(32768)
  while buffer do
    o:write(buffer)
    buffer = i:read(32768)
  end
  i:close()
  o:close()
  return true, "wrote to " .. destination
end

-- The place we grab photos from; must be absolute path
SOURCE=arg[1]
if not SOURCE then 
	-- Probably a good idea to change this to where the card or camera
	-- usually is mounted
	SOURCE="/media/SDCARD/DCIM/"
end

-- The place we put photos in; must be absolute path
DEST=arg[2]
if not DEST then
	-- Probably a good idea to change this to where we put photos on the
	-- local computer's hard disk
	DEST="/home/name/Photos/Camera/"
end

if not lfs.attributes(SOURCE) then
	print("Can not find " .. SOURCE)
	os.exit(1)
end

if not lfs.attributes(DEST) then
	print("Can not find " .. DEST)
	os.exit(1)
end

if not lfs.chdir(SOURCE) then
	print("Could not cd to " .. SOURCE)
	os.exit(1)
end

for s in lfs.dir(".") do
	local a = {}
	if s ~= "." and s ~= ".." then a = lfs.attributes(s) end
	if a.mode == "directory" then
		lfs.chdir(s)
		print("entered " .. s)
		b = lfs.attributes(DEST .. "/" .. s)	
		if not b then
			print("making " .. DEST .. "/" .. s)
			if not lfs.mkdir(DEST .. "/" .. s) then
				print("Could not make " .. DEST .. "/" .. s)
				os.exit(1)
			end
		end
		for file in lfs.dir(".") do
			c = lfs.attributes(file)
			if c.mode == "file" then
				print("saw " .. file)
				e = lfs.attributes(DEST .."/".. s .."/".. file)
				if not e then
					if fileCopy(file, 
						DEST .."/".. s .."/".. file)
					then print("copied " .. file) end
				end
			end
		end
		lfs.chdir("..")
	end
end

