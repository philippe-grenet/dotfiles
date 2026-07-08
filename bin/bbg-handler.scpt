-- from https://bbgithub.dev.bloomberg.com/pkryger/dotfiles_and_bin_mac/tree/fb7538343b3fe76a7c8f5c14c04bac6c054d8e08
-- may need a couple more files (i.e., bbg.ps1)
on open location this_URL
	set vmrun to "/Applications/VMware Fusion.app/Contents/Public/vmrun"
	set vm to "/Users/Shared/Virtual Machines/Windows 10 x64.vmwarevm"
	set this_URL to do shell script "echo " & this_URL & " | tr a-z A-Z"
	set this_URL to do shell script "php -r 'echo urldecode(\"" & this_URL & "\");'"
	-- the following would be the correct way, but it seems that vmrun is not passing args correctly
	-- do shell script quoted form of vmrun & " -T fusion -gu traveler -gp bbuser runProgramInGuest " & quoted form of vm & " -noWait -interactive c:/blp/Wintrv/BbgProtocolHandler.exe " & this_URL
	do shell script quoted form of vmrun & " -T fusion -gu traveler -gp bbuser runProgramInGuest " & quoted form of vm & " -noWait -interactive c:/Windows/SysWOW64/WindowsPowerShell/v1.0/powershell.exe -executionpolicy bypass -File c:/Users/traveler/bbg.ps1 " & this_URL
end open location
