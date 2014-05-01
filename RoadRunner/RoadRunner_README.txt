RoadRunner - WISC_S14 (assemble, compile, simulate) python script

Requirements:
1. Linux/OSX, NO Windows. CAE works best BUT see note below. Don't use CS mumble, their ModelSim (vsim) version is very old.
2. ('iverilog', 'vvp') commands should be available for vvp mode, ('vlib', 'vmap', 'vlog', 'vsim') commands should be available for vsim mode.
3. python2.7+ (NOT python3.x)

Note: Some locale issues in CAE can mess up perl scripts such as our assembler (huge pain). Use the following steps if you see perl locale warning messages on CAE when you log in via ssh like this:
		"perl: warning: Setting locale failed.
		perl: warning: Please check that your locale settings:
			LANGUAGE = (unset),
			LC_ALL = (unset),
			LC_CTYPE = "UTF-8",
			LANG = "en_US.UTF-8"
		    are supported and installed on your system.
		perl: warning: Falling back to the standard locale ("C")."

		Steps:
		1. Open your ~/.bashrc file (be EXTREMELY careful, if you modify the file incorrectly, all bad things happen) using your favorite editor.
		2. Add the following lines to the end of the file:
				export LANGUAGE=en_US.UTF-8
				export LANG=en_US.UTF-8
				export LC_ALL=en_US.UTF-8
		3. Make sure you did not change anything else, save and close the file.
		4. Log out and log back in, that's it. If you did it right, you will still see the warning when you ssh, but it should not affect this script.

How to run:
0. Create a .tar.gz file of your design as follows:
		tar cvzf my_tar_file_blah.tar.gz IF.v ID.v blah.v whatever.v other_files.v
Note that your .tar.gz cannot have any directories, only your design files without any subdirectories. See hints below for what you should and what you shouldn't have in your .tar.gz file.
1. Create a new empty directory, DO NOT use an existing directory since the script deletes files and directories as it wishes.
2. Copy RoadRunner.tar.gz into the empty directory you created in step 1, cd into that directory and run:
		tar xvzf RoadRunner.tar.gz
from that directory.
This should give you the following resulting structure:
		asmbl.pl*  programs/  provided_modules/  ref/  RoadRunner.py*  RoadRunner.tar.gz tars_dir/
3. Copy your my_tar_file_blah.tar.gz file into tars_dir/
4. Run the following command from inside the directory you created in step 1:
		./RoadRunner.py
You can use the --ignore_pc flag if you don't want to check your PC (we WILL check your PC to see if it matches what is specified in the ISA sheet) and --no_debug flag if you don't want to see too many debug messages printed out. --sim=vvp is one useful option if you want to run locally using only iverilog. Use --help to see all the available options.
5. At the end, you should have the results file in my_tar_file_blah.tar.gz_extracted/RoadRunner_results.txt
6. The files in provided_modules/ directory will overwrite the files in your design after extraction from the .tar.gz, this is why you cannot change the name, interface or implementation of ANY of the modules provided to you on the course webpage, including rf, cache, etc.
7. Your assembly programs (or tests) should be in the programs/ directory with .txt or .asm extensions, all other files will be ignored.

Hints:
Read and do the following carefully:
1. Whenever you have a $readmemh, use only the file name and NOT the full path for the same reason mentioned in step 2. For example, in your instr_mem.v and cache.v later, use 'instr.hex' only and NOT the full path to it.
2. If you use any header files (eg. `include 'blah_blah.vh') as part of your design, DON'T use full paths since they won't exist when we evaluate your design using our tests and this script. Instead, use 'file_name.vh' without the path in front of it.
3. Notice that I used the extension .vh for header files, this is ABSOLUTELY important. Otherwise, this script will compile all .v files including your header files and it will result in a compilation error, since a .v file must have module-endmodule statements to be valid and your header file won't have it.
4. DON'T have any $readmemh in your register file, that was only for your debugging purposes and could cause errors during simulation using this script since the file won't exist.
5. DON'T have multiple files defining the same module in your my_tar_file_blah.tar.gz. This will cause tons of problems depending on the order in which these files get compiled. For example, if you have both add.v and add_bak.v in your .tar.gz file defining the add module, then it is not known which one will get used during simulation. This can cause simulation errors if the wrong file is used and you will be responsible for it.
6. DON'T have any files other than .v, .vh, .sv and .vs design files in your .tar.gz file and avoid duplicates. Make sure your .tar.gz can compile and simulate using this script as stated in "How to run".
7. If you use ModelSim UI, it will not know where to pick up your include files or instr.hex files without the full path, you need to tell it where to look using include directories option. Right-click on a design file that includes a header file and under one of the tabs named "Verilog & SystemVerilog", you can specify "Include Directory" as your project directory containing your design files. This way, your header files from your project directory will get picked up automatically. This is only needed when you're running ModelSim UI, not when you're using this script.
