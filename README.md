
	Red Button Linux kernel release 1.2.xx

These are the release notes for linux version 1.2.  Read them carefully,
as they tell you what this is all about, explain how to install the
kernel, and what to do if something goes wrong. 

WHAT IS LINUX?

  Linux is a Unix clone for 386/486-based PCs written from scratch by
  Linus Torvalds with assistance from a loosely-knit team of hackers
  across the Net.  It aims towards POSIX compliance. 

  It has all the features you would expect in a modern fully-fledged
  Unix, including true multitasking, virtual memory, shared libraries,
  demand loading, shared copy-on-write executables, proper memory
  management and TCP/IP networking. 

  It is distributed under the GNU General Public License - see the
  accompanying COPYING file for more details. 

LINUX FRAMEWORK:

                        passive code
                +----------------------------+
                |                            |
                |        stop device         |
                |         /drivers           |
                |                            |
    cpu int 00: +----------------------------+

                        active code
                +----------------------------+
                |                            |
                |       start device         |
                |        /drivers            |
                |                            |
                +----------------------------+
                |                            |
                |        /fs, /net           |
                |                            |
                +----------------------------+
                |                            |
                |        /kernel             |
                |                            |
    cpu int 80: +----------------------------+

                         user code
                +----------------------------+
                |                            |
                |      /usr/src/task1        |
                |                            |
                +----------------------------+

                         user code
                +----------------------------+
                |                            |
                |      /usr/src/task2        |
                |                            |
                +----------------------------+

                         user code
                +----------------------------+
                |                            |
                |      /usr/src/task3        |
                |                            |
                +----------------------------+

                         user code
                +----------------------------+
                |                            |
                |      /usr/src/task4        |
                |                            |
                +----------------------------+

DOCUMENTATION:

 - there is a lot of documentation available both in electronic form on
   the internet and in books, both Linux-specific and pertaining to
   general UNIX questions.  I'd recommend looking into the documentation
   subdirectories on any Linux ftp site for the LDP (Linux Documentation
   Project) books.  This README is not meant to be documentation on the
   system: there are much better sources available.

INSTALLING the kernel:

 - If you install the full sources, do a

		cd /usr/src
		gzip -cd linux-1.2.XX.tar.gz | tar xfv -

   to get it all put in place. Replace "XX" with the version number of the
   latest kernel.

 - Installing by patching is not worth the effort because the full set of
   patches is bigger than a new kernel distribution. Instead, get the
   latest full source archive and install as above. Then, get all newer
   patch files, and do

		cd /usr/src
		gzip -cd patchXX.gz | patch -p0

   (repeat xx for all versions bigger than the version of your current
   source tree, _in_order_) and you should be ok.  You may want to remove
   the backup files (xxx~ or xxx.orig), and make sure that there are no
   failed patches (xxx# or xxx.rej). If there are, either you or me has
   made a mistake.

 - make sure your /usr/include/linux and /usr/include/asm directories
   are just symlinks to the kernel sources:

		cd /usr/include
		rm -rf linux
		rm -rf asm
		ln -s /usr/src/linux/include/linux linux
		ln -s /usr/src/linux/include/asm-i386 asm

 - make sure you have no stale .o files and dependencies lying around:

		cd /usr/src/linux
		make mrproper

   You should now have the sources correctly installed.

CONFIGURING the kernel:

 - do a "make config" to configure the basic kernel.  "make config"
   needs bash to work: it will search for bash in $BASH, /bin/bash and
   /bin/sh (in that order), so hopefully one of those is correct. 

	NOTES on "make config":
	- having unnecessary drivers will make the kernel bigger, and can
	  under some circumstances lead to problems: probing for a
	  nonexistent controller card may confuse your other controllers
	- compiling the kernel with "-m486" for a number of 486-specific
	  will result in a kernel that still works on a 386: it may be
	  slightly larger and possibly slower by an insignificant amount,
	  but it should not hurt performance. 
	- A kernel with math-emulation compiled in will still use the
	  coprocessor if one is present: the math emulation will just
	  never get used in that case.  The kernel will be slightly larger,
	  but will work on different machines regardless of whether they
	  have a math coprocessor or not. 
	- the "kernel hacking" configuration details usually result in a
	  bigger or slower kernel (or both), and can even make the kernel
	  less stable by configuring some routines to actively try to
	  break bad code to find kernel problems (kmalloc()).  Thus you
	  should probably answer 'n' to the questions for a "production"
	  kernel. 

 - Check the top Makefile for further site-dependent configuration
   (default SVGA mode etc). 

 - Finally, do a "make dep" to set up all the dependencies correctly. 

COMPILING the kernel:

 - make sure you have gcc-2.5.8 or newer available.  It seems older gcc
   versions can have problems compiling newer versions of linux.  If you
   upgrade your compiler, remember to get the new binutils package too
   (for as/ld/nm and company). Do not use gcc-2.6.0; it has a few serious
   bugs.

 - do a "make zImage" to create a compressed kernel image.  If you want
   to make a bootdisk (without root filesystem or lilo), insert a floppy
   in your A: drive, and do a "make zdisk".  It is also possible to do
   "make zlilo" if you have lilo installed to suit the kernel makefiles,
   but you may want to check your particular lilo setup first. 

 - keep a backup kernel handy in case something goes wrong. 

 - In order to boot your new kernel, you'll need to copy the kernel
   image (found in /usr/src/linux/arch/i386/boot/zImage after compilation)
   to the place where your regular bootable kernel is found. 

   For some, this is on a floppy disk, in which case you can "cp
   /usr/src/linux/arch/i386/boot/zImage /dev/fd0" to make a bootable
   floppy. 

   If you boot Linux from the hard drive, chances are you use LILO which
   uses the kernel image as specified in the file /etc/lilo.conf.  The
   kernel image file is usually /vmlinuz, or /zImage, or /etc/zImage. 
   To use the new kernel, copy the new image over the old one (save a
   backup of the original!).  Then, you MUST RERUN LILO to update the
   loading map!! If you don't, you won't be able to boot the new kernel
   image. 

   Reinstalling LILO is usually a matter of running /sbin/lilo. 
   You may wish to edit /etc/lilo.conf to specify an entry for your
   old kernel image (say, /vmlinux.old) in case the new one does not
   work.  See the LILO docs for more information. 

   After reinstalling LILO, you should be all set.  Shutdown the system,
   reboot, and enjoy!

   If you ever need to change the default root device, video mode,
   ramdisk size, etc.  in the kernel image, use the 'rdev' program (or
   alternatively the LILO boot options when appropriate).  No need to
   recompile the kernel to change these parameters. 

 - reboot with the new kernel and enjoy. 

IF SOMETHING GOES WRONG:

 - if you have problems that seem to be due to kernel bugs, please mail
   them to me (Linus.Torvalds@Helsinki.FI), and possibly to any other
   relevant mailing-list or to the newsgroup.  The mailing-lists are
   useful especially for SCSI and NETworking problems, as I can't test
   either of those personally anyway. 

 - In all bug-reports, *please* tell what kernel you are talking about,
   how to duplicate the problem, and what your setup is (use your common
   sense).  If the problem is new, tell me so, and if the problem is
   old, please try to tell me when you first noticed it.

 - if the bug results in a message like

	unable to handle kernel paging request at address C0000010
	Oops: 0002
	EIP:   0010:XXXXXXXX
	eax: xxxxxxxx   ebx: xxxxxxxx   ecx: xxxxxxxx   edx: xxxxxxxx
	esi: xxxxxxxx   edi: xxxxxxxx   ebp: xxxxxxxx
	ds: xxxx  es: xxxx  fs: xxxx  gs: xxxx
	Pid: xx, process nr: xx
	xx xx xx xx xx xx xx xx xx xx

   or similar kernel debugging information on your screen or in your
   system log, please duplicate it *exactly*.  The dump may look
   incomprehensible to you, but it does contain information that may
   help debugging the problem.  The text above the dump is also
   important: it tells something about why the kernel dumped code (in
   the above example it's due to a bad kernel pointer)

 - in debugging dumps like the above, it helps enormously if you can
   look up what the EIP value means.  The hex value as such doesn't help
   me or anybody else very much: it will depend on your particular
   kernel setup.  What you should do is take the hex value from the EIP
   line (ignore the "0010:"), and look it up in the kernel namelist to
   see which kernel function contains the offending address.

   To find out the kernel function name, you'll need to find the system
   binary associated with the kernel that exhibited the symptom.  This is
   the file 'linux/vmlinux'.  To extract the namelist and match it against
   the EIP from the kernel crash, do:

		nm vmlinux | sort | less

   This will give you a list of kernel addresses sorted in ascending
   order, from which it is simple to find the function that contains the
   offending address.  Note that the address given by the kernel
   debugging messages will not necessarily match exactly with the
   function addresses (in fact, that is very unlikely), so you can't
   just 'grep' the list: the list will, however, give you the starting
   point of each kernel function, so by looking for the function that
   has a starting address lower than the one you are searching for but
   is followed by a function with a higher address you will find the one
   you want.  In fact, it may be a good idea to include a bit of
   "context" in your problem report, giving a few lines around the
   interesting one. 

   If you for some reason cannot do the above (you have a pre-compiled
   kernel image or similar), telling me as much about your setup as
   possible will help. 

 - alternately, you can use gdb on a running kernel. (read-only; i.e. you
   cannot change values or set break points.) To do this, first compile the
   kernel with -g; edit arch/i386/Makefile appropriately, then do a "make
   clean". You'll also need to enable CONFIG_PROC_FS (via "make config").

   After you've rebooted with the new kernel, do "gdb vmlinux /proc/kcore".
   You can now use all the usual gdb commands. The command to look up the
   point where your system crashed is "l *0xXXXXXXXX". (Replace the XXXes
   with the EIP value.)

   gdb'ing a non-running kernel currently fails because gdb (wrongly)
   disregards the starting offset for which the kernel is compiled.
