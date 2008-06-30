Return-Path: <linux-kernel-owner+w=401wt.eu-S1760997AbYF3Lha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbYF3Lha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 07:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbYF3LhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 07:37:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35995 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbYF3LhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 07:37:12 -0400
Subject: [ANNOUNCE] The Linux Test Project has been Released for JUNE 2008
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Davide Libenzi <davidel@xmailserver.org>, rusty <rusty@rustcorp.com.au>,
       Bryce Harrington <bryce@canonical.com>,
       Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>,
       Vernon Mauery <vernux@us.ibm.com>,
       Louis Rilling <Louis.Rilling@kerlabs.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Roy Lee <roylee@andestech.com>,
       Andrew Vagin <avagin@gmail.com>, vechandr <vechandr@in.ibm.com>,
       AIME LE-ROUZIC <Aime.Le-Rouzic@bull.net>,
       Garrett Cooper <yanegomi@gmail.com>,
       Giuseppe Cavallaro <peppe.cavallaro@st.com>,
       Carmelo AMOROSO <carmelo.amoroso@st.com>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       Chirag Jog <chirag@linux.vnet.ibm.com>,
       Max Stirling <vickyirobot@gmail.com>, Shi Weihua <shiwh@cn.fujitsu.com>,
       Masatake YAMATO <yamato@redhat.com>,
       Matthieu =?ISO-8859-1?Q?Fertr=E9?= <mfertre@irisa.fr>,
       Matt Fleming <mjf@gentoo.org>
Content-Type: multipart/mixed; boundary="=-tUPlhz5SWdLwwgcPqaeE"
Organization: IBM
Date: Mon, 30 Jun 2008 17:06:54 +0530
Message-Id: <1214825814.4603.41.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tUPlhz5SWdLwwgcPqaeE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Dear All,

The Linux Test Project test suite has been released for the month of
JUNE 2008. The latest version of the test-suite contains 3000+ tests
for the Linux OS and can be found at
http://ltp.sourceforge.net/.
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.


JUNE 2008 Highlights:

* Addition of timerfd(), utimensat(), gettid() & io_cancel() tests,
* Addition of CPU & MEMORY HOTPLUG tests,
* Addition of Process Event Connector tests,
* Addition of Hackbench test,
* RT tests fix for START_LATENCY,
* FS_BIND fix for ia64 & for kernels below 2.6.15,
* SE-Linux fix to build against the latest refpolicy headers,
* Concurrency Fixes for some tests.


JUNE 2008 LTP Contributors:

* Masatake YAMATO,
* Davide Libenzi,
* Rusty Russell,
* Michael Kerrisk,
* Bryce Harrington,
* Stephen Smalley,
* Renaud Lottiaux,
* Vernon Mauery,
* Louis Rilling,
* Li Zefan,
* Roy Lee,
* Andrew Vagin,
* Veerendra Chandrappa,
* Le Rouzic,
* Garrett Cooper,
* Giuseppe Cavallaro,
* Carmelo Amoroso,
* Chirag Jog,
* Max Stirling,
* Shi Weihua,
* Matthieu Fertré,
* Matt Fleming,


Note(s) from the Maintainer:

June 2008 saw the initiation of Project collaboration. Thanks to
Masatake Yamato, who will help in porting a significant amount of
syscall test cases from the Crackerjack Project to LTP. I am also
excited to see that new test cases are being submitted to LTP with
increasing pace. I hope that the pace accelerates much much more. The
next half of 2008 will also see some major Infrastructural improvements
in LTP along with our unending endeavor to add more test cases. From now
onwards i would also like to acknowledge each and every contributor in
this release mail for their valuable contribution(s). I will release
results on 2 diff. kernels(one a bit old and another a bit younger) on
same architecture and for those architectures available at my disposal.
This will help us to compare results for 2 extreme kernels.


Our web site also contains other information such as:
- A Linux test tools matrix
- Technical papers
- How To's on Linux testing
- Code coverage analysis tool.

We would encourage the community to post results to
ltp-results@lists.sf.net,
patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382
(for New Bug(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382
(for New Patch(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382
(for New Feature Request(s))

Please also see the Change Log Attached (JUNE 2008) for detailed
changes.

Happy testing, 
Regards-- 
Subrata,

--=-tUPlhz5SWdLwwgcPqaeE
Content-Disposition: attachment; filename=June-2008_Changelog.txt
Content-Type: text/plain; name=June-2008_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: 8bit

1) Log Message:
These tests were contributed by the timerfd() syscall developer Davide Libenzi <davidel@xmailserver.org>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/timerfd/Makefile
ltp/testcases/kernel/syscalls/timerfd/timerfd01.c

2) Log Message:
CPU and MEMORY HOTPLUG test cases picked up from http://devresources.linux-foundation.org/dev/hotplug/

Added Files:
ltp/testcases/kernel/hotplug/cpu_hotplug/COPYING
ltp/testcases/kernel/hotplug/cpu_hotplug/ChangeLog
ltp/testcases/kernel/hotplug/cpu_hotplug/README
ltp/testcases/kernel/hotplug/cpu_hotplug/runtests.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/doc/hotplug01.txt
ltp/testcases/kernel/hotplug/cpu_hotplug/doc/hotplug02.txt
ltp/testcases/kernel/hotplug/cpu_hotplug/doc/hotplug03.txt
ltp/testcases/kernel/hotplug/cpu_hotplug/doc/hotplug04.txt
ltp/testcases/kernel/hotplug/cpu_hotplug/doc/hotplug05.txt
ltp/testcases/kernel/hotplug/cpu_hotplug/doc/hotplug06.txt
ltp/testcases/kernel/hotplug/cpu_hotplug/doc/todo.txt
ltp/testcases/kernel/hotplug/cpu_hotplug/functional/hotplug01.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/functional/hotplug02.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/functional/hotplug03.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/functional/hotplug04.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/functional/hotplug06.sar.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/functional/hotplug06.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/functional/hotplug06.top.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/functional/hotplug07.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/include/hotplug.fns
ltp/testcases/kernel/hotplug/cpu_hotplug/include/testsuite.fns
ltp/testcases/kernel/hotplug/cpu_hotplug/tools/do_disk_write_loop
ltp/testcases/kernel/hotplug/cpu_hotplug/tools/do_kcompile_loop
ltp/testcases/kernel/hotplug/cpu_hotplug/tools/do_spin_loop
ltp/testcases/kernel/hotplug/cpu_hotplug/tools/report_proc_interrupts
ltp/testcases/kernel/hotplug/memory_hotplug/COPYING
ltp/testcases/kernel/hotplug/memory_hotplug/Makefile
ltp/testcases/kernel/hotplug/memory_hotplug/README
ltp/testcases/kernel/hotplug/memory_hotplug/TODO
ltp/testcases/kernel/hotplug/memory_hotplug/commands.c
ltp/testcases/kernel/hotplug/memory_hotplug/debug.h
ltp/testcases/kernel/hotplug/memory_hotplug/memtoy.c
ltp/testcases/kernel/hotplug/memory_hotplug/memtoy.h
ltp/testcases/kernel/hotplug/memory_hotplug/migrate_pages.c
ltp/testcases/kernel/hotplug/memory_hotplug/migrate_pages.h
ltp/testcases/kernel/hotplug/memory_hotplug/segment.c
ltp/testcases/kernel/hotplug/memory_hotplug/segment.h
ltp/testcases/kernel/hotplug/memory_hotplug/version.h
ltp/testcases/kernel/hotplug/memory_hotplug/Scripts/test1
ltp/testcases/kernel/hotplug/memory_hotplug/Scripts/test1c
ltp/testcases/kernel/hotplug/memory_hotplug/Scripts/test1c8
ltp/testcases/kernel/hotplug/memory_hotplug/Scripts/test1f
ltp/testcases/kernel/hotplug/memory_hotplug/Scripts/test1l
ltp/testcases/kernel/hotplug/memory_hotplug/Scripts/test1la
ltp/testcases/kernel/hotplug/memory_hotplug/Scripts/test1shm
ltp/testcases/kernel/hotplug/memory_hotplug/Scripts/test2
ltp/testcases/kernel/hotplug/memory_hotplug/Scripts/test2l
ltp/testcases/kernel/hotplug/memory_hotplug/Scripts/test3
ltp/testcases/kernel/hotplug/memory_hotplug/Scripts/test3-1m
ltp/testcases/kernel/hotplug/memory_hotplug/Scripts/test3l
ltp/testcases/kernel/hotplug/memory_hotplug/Scripts/test4
ltp/testcases/kernel/hotplug/memory_hotplug/Scripts/test4f
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-lazy-2shm-1m
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-lazy-anon-1g
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-lazy-anon-1g-interleaved
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-lazy-anon-1g-touch
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-lazy-anon-1p
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-lazy-anon-8p
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-lazy-anon-8p-nomig
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-lazy-anon-8p-touch
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-lazy-file-16m
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-lazy-file-16m-touch
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-lazy-file-1m
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-lazy-file-1m-touch
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-lazy-file-8p
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-lazy-shm-8p
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-mpm-2shm-1m
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-mpm-anon-1g
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-mpm-anon-1g-interleaved
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-mpm-anon-1p
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-mpm-anon-8p
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-mpm-file-16m
ltp/testcases/kernel/hotplug/memory_hotplug/Xpm-tests/test-mpm-file-1m

3) Log Message:
This patch fix a concurrency issue in mremap04. The tmp directory the IPC key was build with was destroyed before we destroy the IPC ressource attached to the key. In case of concurency, the same inode id can be reused for another process tmp dir, leading to the generation of the same key. Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/mremap/mremap04.c

4) Log Message:
I spent some time looking at the sched_latency test trying to see why it took so long to start the thread.  The java version of the test takes a comparable amount of time to start the thread as it does for each period. The rt-test version was taking an order of magnitude longer.  After digging through the java documentation, I found that the RealtimeThread does not actually start executing until the RealtimeThread.waitForNextPeriod() fulfills the time specified in the PeriodicParameters parameter included in its constructor.  So all the tests are scheduled to run about 1 second after the threads are created.  This gives the system plenty of time to create the thread (a non-realtime code path), set the scheduling parameters and then sleep until the specified run time.  The start latency as measured by the test goes something like this: 

start_time = nanoTime() + 1000000000;
rt = new realtimeThread(sched_param, new \
        PeriodicParameters(start_time, ...), ..., run);

/* by the rtsj specification, this method will not run until start_time */
run() {
        now = nanoTime();
        start_latency = now - start_time;
        ...
}

The rt-tests version went something like this:

start_time = rt_gettime();
create_fifo_thread(periodic_thread, (void*)0, PRIO);

periodic_thread() {
        now = rt_gettime();
        start_latency = now - start;
        ...
}

As you can see, the start_latency is a very different measurement in these two cases.  In the first, it is basically the initial starting latency as measured by the remainder of the loops.  In the second, the execution path of creating the pthread is also counted in the latency.  While this might be an important number for us to keep low in our testing, this is not what the java test is measuring. This patch puts the rt-test version in line with the java version. I also think this is reasonable since the rt-wiki says that we should _NEVER_ create threads on the real-time stage. Signed-off-by: Vernon Mauery <vernux@us.ibm.com>. 

Modified File(s):
ltp/testcases/realtime/func/sched_latency/sched_latency.c
ltp/testcases/realtime/include/librttest.h
ltp/testcases/realtime/lib/librttest.c

5) Log Message:
The following patches fix execve05 for error reporting when execve() succeeds, and exit synchronization in loaded systems. The last two patches are minor cleanups. execve05 checks that execve() fails if a process has opened the file with write access. However, in case the test fails and execve() succeeds, the default binary (test3) has return code 0, which is interpreted as test success. We get output like that:

<output>
Hello World
</output>
with return code 0 (success)

instead of:

<output>
execve05    1  FAIL  :  Failures reported above
</output>
with return code matching FAIL.

This patch simply changes the success return code from 0 to 3, so that execve() success, and thus test failure, can be properly reported. Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>.

Modified Files:
ltp/testcases/kernel/syscalls/execve/execve05.c

6) Log Message:
The following patches fix execve05 for error reporting when execve() succeeds, and exit synchronization in loaded systems. The last two patches are minor cleanups. In execve05, the first child must keep a file open at least until the second child tries to execve() this file. However the test achieves this with a sleep of 10s, which may fail on loaded systems. This patch replaces this (arbitrary) sleep with a pipe-based synchronization, where the parent notifies the first child once the second child has terminated. Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>.

Modified Files:
ltp/testcases/kernel/syscalls/execve/execve05.c

7) Log Message:
The following patches fix execve05 for error reporting when execve() succeeds, and exit synchronization in loaded systems. The last two patches are minor cleanups. In a child, calling waitpid() to wait for the death of sibling child is simply non-sense. Moreover in execve05, the second child does not need such synchronization. Remove it. Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>.

Modified Files:
ltp/testcases/kernel/syscalls/execve/execve05.c

8) Log Message:
The following patches fix execve05 for error reporting when execve() succeeds, and exit synchronization in loaded systems. The last two patches are minor cleanups. cleanup() is reserved for the main test process. In children, call exit() instead. Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>. 

Modified Files:
ltp/testcases/kernel/syscalls/execve/execve05.c

9) Log Message:
This patch fix an issue in the sync_pipe implementation. The problem is the following : after the creation of a pipe we do not close any file descriptor until the end of a test. Let's imagine the following execution : 
- Process A calls sync_pipe_create
- Process A do a fork (creation of process B)
- Process A calls sync_pipe_wait
---> Process A blocks on sync_pipe_wait
- Process B starts
- Process B exits because of an early error.
In this case, process A never exits. Since it has not closed its write descriptor to the pipe, the pipe is not considered as broken, thus process A is not notified its son is dead. Thus it will wait forever. Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>.

Modified File(s):
ltp/lib/libtestsuite.c

10) Log Message:
This patch fixes a compilation warning due to the function "sync_pipe_close" which was not exported. Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>.

Modified File(s):
ltp/include/libtestsuite.h

11) Log Message:
After the patch from Roy moveing the libtestsuite code from /testcases/kernel/syscalls/lib to /lib, the code in the old directory has not been removed. Moreover, include PATH in some makefile was still pointing to this old directory. This patch remove libtestsuite code from the old directory and remove deprecated references to this old dir in some Makefiles. Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>.

Modified Files:
ltp/testcases/kernel/syscalls/ipc/msgrcv/Makefile
ltp/testcases/kernel/syscalls/ipc/msgrcv/msgrcv05.c
ltp/testcases/kernel/syscalls/ipc/msgsnd/Makefile
ltp/testcases/kernel/syscalls/ipc/msgsnd/msgsnd06.c
ltp/testcases/kernel/syscalls/ipc/semctl/Makefile
ltp/testcases/kernel/syscalls/ipc/semop/Makefile
ltp/testcases/kernel/syscalls/ipc/shmctl/Makefile

Removed Files:
ltp/testcases/kernel/syscalls/lib/Makefile
ltp/testcases/kernel/syscalls/lib/libtestsuite.c
ltp/testcases/kernel/syscalls/lib/libtestsuite.h

12) Log Message:
time-schedule01 failed, because it sent SIGTERM to itself before program exited, so the return value is not 0. This patch makes the main process ignore SIGTERM. Li Zefan <lizf@cn.fujitsu.com>.

Modified File(s):
ltp/testcases/kernel/sched/tool/time-schedule.c

13) Log Message:
This patch fix the make file of fs_bin test case so that it can be cross-built. Roy Lee <roylee@andestech.com>.

Modified File(s):
ltp/testcases/kernel/fs/fs_bind/bin/Makefile

14) Log Message:
Add syscall numbers for timerfd syscalls under i386 and x86_64. Roy Lee <roylee@andestech.com>.

Modified File(s):
ltp/testcases/kernel/include/i386.in
ltp/testcases/kernel/include/linux_syscall_numbers.h
ltp/testcases/kernel/include/x86_64.in

15) Log Message:
Currently, timerfd01 test case blocks building process for architectures that haven’t prepared for it. This patch modify it to be more generic for all architectures. Roy Leee <roylee@andestech.com>.

Modified  File(s):
ltp/testcases/kernel/syscalls/timerfd/timerfd01.c

16) Log Message:
It looks like the only thing that didn't apply was the function declaration. It builds (with a warning) and runs just fine. But here is a patch to fix the warning. Signed-off-by: Vernon Mauery <vernux@us.ibm.com>.

Modified File(s):
ltp/testcases/realtime/include/librttest.h

17) Log Message:
utimensat() syscall was introduced from linux-2.6.22 onwards. Michael wrote the initial testcases, and, the same is being contributed to LTP under GPLv2. I worked out a patch for this. Though this is not using LTP specific libraries at the moment. But the tests run well and tests 99 separate variations. Michael has written it through itś length and breadth. I generated the code coverage (9.2%) over 2.6.25-gcov kernel, which however was not built with <make allmodconfig> option. Please see it attached along with a draft man page of utimensat(), created by Michael. Let us know how do you feel about this test. We can then go ahead and add this to LTP. Signed-off-by Michael Kerrisk <mtk.manpages@googlemail.com>. Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.com>.

Modified File(s):
ltp/runtest/syscalls

Added Files:
ltp/testcases/kernel/syscalls/utimensat/Makefile
ltp/testcases/kernel/syscalls/utimensat/utimensat01.c
ltp/testcases/kernel/syscalls/utimensat/utimensat_tests.sh

18) Log Message:
On ia64, __clone2() is used instead of clone(). Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>.

Modified File(s):
ltp/testcases/kernel/fs/fs_bind/bin/nsclone.c

19) Log Message:
I execute fork12 test and OMM killer begin send SIGKILL to its children and fork return success always. fork12 hang up in this case, so I create the patch (see attach), which check whether someone child killed and if it occur, return number of forked processes. Andrew Vagin <avagin@gmail.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/fork/fork12.c

20) Log Message:
This patch fixes the writetest.c  to return proper status on Failure/Success. At present the return code of the writest.c is 'zero' for both Success and Failure. As per norms non-zero value should be returned for error , so fixing this testcase. Signed off : Veerendra C <vechandr@in.ibm.com>.

Modified File(s):
ltp/testcases/kernel/io/writetest/writetest.c

21) Log Message:
mallocstress stresses the VMM and C library  by spawning N threads which malloc blocks of increasing size until malloc returns NULL. It occur because test doesn't wait for all thread started. already started threads begin allocate memory, so pthread_create can return ENOMEM. my patch added this synchronizing. I use semaphore, because it can wait-for-zero unlike pthread_mutex. sorry, forgot set permission in semget, new patch attached. Andrew Vagin <avagin@gmail.com>.

Modified File(s):
ltp/testcases/kernel/mem/mtest07/mallocstress.c

22) Log Message:
Reverting back the changes done to fcntl-lock tests in May 2008 release, as this would have canceled the operation Revision *1.1  *done on the /Mon Sep 11 20:40:52 2006 UTC/ by /mreed10 /which added "A patch that added new functionality into the NFSvf lock tests. 
-fixes bugs 
-adds the capability to stress a server with multiple clients"
So it is possible to get back to what 's in ltp-full-20080430 and add my fix: You can fix it by replacing in the locktests.c file
     buf=(char *)malloc(clnt*maxClients);
by
     buf=(char *)malloc(clnt*(maxClients+1));
Signed-off-by: Le Rouzic <aime.le-rouzic@bull.net>.

Modified File(s):
ltp/testcases/network/nfsv4/locks/Makefile
ltp/testcases/network/nfsv4/locks/locktests.c

Added Files:
ltp/testcases/network/nfsv4/locks/locktests.h

Removed Files:
ltp/testcases/network/nfsv4/locks/test


23) Log Message:
In the manpage for tst_res(3) in the April snapshot it says...
       tst_brk - Print result message and break remaining test cases
       tst_brkm  -  Print  result  message, including file contents, and break remaining test cases
... at the top of the page. The prototypes and the logic is backwards for the summaries. A patched manpage is provided. Garrett Cooper <yanegomi@gmail.com>.

Modified File(s):
ltp/doc/man3/tst_res.3

24) Log Message:
Force the catch_sighup to be volatile in order to overcome an issue due to the compiler optimization. In fact, compiling the test with -Os the catch_sighup variable is not set to 1 into the signal handler. At runtime, the  test remain in a loop. No problem compiling without Os or O2.
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
Signed-off-by: Carmelo Amoroso <carmelo.amoroso@st.com>.

Modified File(s):
ltp/testcases/network/stress/ns-tools/ns-mcast_join.c

25) Log Message:
Fix a bug in the sigiotask test and enable the test_fdreceive policy to build against the latest refpolicy headers. Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>.

Modified File(s):
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_fdreceive.te
ltp/testcases/kernel/security/selinux-testsuite/tests/file/selinux_sigiotask.c

26) Log Message:
Included the statement:
	These tests are OSDL/LF and imported into LTP under GPLv2.

Modified File(s):
ltp/testcases/kernel/hotplug/cpu_hotplug/COPYING
ltp/testcases/kernel/hotplug/memory_hotplug/COPYING

27) Log Message:
This patch ensures that async_handler and async_handler_jk runs by default. Also the profile/default is updated to reflect the same. Signed-Off-By: Chirag <chirag@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/realtime/profiles/default

Added Files:
ltp/testcases/realtime/func/async_handler/run_auto.sh

28) Log Message:
Looks like the else is missing since in both the cases where flag is set to one or not we get the test broken print. Signed-off-by: Max Stirling <vickyirobot@gmail.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/vmsplice/vmsplice01.c

29) Log Message:
we have some truble with mapping api functions (such as tst_exit) in bash (./tools/apicmds/ltpapicmd.c). Now this problem may be fixed if added "exit" after tst_exit, but it's temporary. We should redesign this system and describe it in documentation. Andrew Vaggin <avagin@parallels.com>.

Modified File(s):
ltp/testscripts/test_fs_bind.sh

30) Log Message:
signal_test_01 failed on ia64, the following message outputed:
---------------------------
ERROR [line: 146] sigaltstack failed: Cannot allocate memory
: Cannot allocate memory
signal_test_01: IPC Signals TestSuite program
---------------------------
And, i found the defined macro STACKSIZE is short on ia64. This patch fix it. Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>.

Modified File(s):
ltp/testcases/kernel/ipc/ipc_stress/signal_test_01.c

31) Log Message:
signal_test_05 failed on ia64 and x86_64, the following message outputed:
---------------------------
ERROR [line: 145] child process exited abnormally
---------------------------
Some signals which are ignored in ignore_signals() are not ignored in child(). e.g., 32, 33. (SIGRTMIN is 34). So we should reuse ignore_signals()'s signal ignoring code in child(). Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>.

Modified File(s):
ltp/testcases/kernel/ipc/ipc_stress/signal_test_05.c

32) Log Message:
Updating to include info about all other LTP man pages. Subrata Modak <subrata@linux.vnet.ibm.com>

Modified File(s):
ltp/README.ltp-devel

33) Log Message:
I've ported a testcase for gettid() from crackerjack to ltp. I've added a directory ltp/testcases/kernel/syscalls/gettid. Signed-off-by: Masatake YAMATO <yamato@redhat.com>

Modified Files:
ltp/runtest/syscalls

Added Files:
ltp/testcases/kernel/syscalls/gettid/Makefile
ltp/testcases/kernel/syscalls/gettid/gettid01.c

34) Log Message:
I found wrong format string usage in ltp/testcases/kernel/syscalls/exit/exit02.c: returned value from strerror is not used. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/exit/exit02.c

35) Log Message:
This patch fix a concurrency issue in semctl06. The IPC keys used for this test could conflict with keys from another task. Signed-off-by: Matthieu Fertré <mfertre@irisa.fr>.

Modified File(s):
ltp/testcases/kernel/syscalls/ipc/semctl/semctl06.c

36) Log Message:
The attached patch was necessary in order to get LTP to build for our embedded system at work. Without this patch testcases that use the my_getpwnam() library function suffer from redeclaration errors. Signed-off-by: Matt Fleming <mjf@gentoo.org>.

Modified File(s):
ltp/lib/Makefile

37) Log Message:
Addition of enhanced test plan by Cai Qian <qcai@redhat.com>.

Modified File(s):
ltp/testcases/kdump/doc/TEST_PLAN.txt

38) Log Message:
Fixed the way how to run the "tc" command on the remote machine. Otherwise, we always get the following message on the local side: The remote host does not have netem functionality. Signed-off-by: Giuseppe Cavallaro@st.com.

Modified File(s):
ltp/testcases/network/stress/ns-tools/check_netem

39) Log Message:
Running the UDP network stress tests on my SH4 target I have had to modify the following scripts: killall_udp_traffic and udp4-multi-diffip01. It deletes the address before setting it to avoid the following error: RTNETLINK answers: File exists; it implies that the test fails. Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>.

Modified File(s):
ltp/testcases/network/stress/udp/multi-diffip/udp4-multi-diffip01

40) Log Message:
This modifies the command sent to the remote host just to kill the ns-udpclient script. Indeed, it seems that the previous string always returns 1. Moreover, it adds a new check to verify if the return value is not empty. It could happen, for example, if the RSH returns sometime the following error: poll: protocol failure in circuit setup. Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>.

Modified File(s):
ltp/testcases/network/stress/ns-tools/killall_udp_traffic

41) Log Message:
Attached a new patch just to add the same fixes I provided you for icpm and tcp network stress as well. On SH4 STB with STLinux distribution we are able to run all the network stress tests without any failures. Due to configuration issues we do not run the multi-diffnic tests (because they require plural Network cards for host). It modifies the command sent to the remote host to kill tcp/icmp clients. It also deletes the address before setting it to avoid the following error:  "RTNETLINK answers: File exists". This implies that the test fails. Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>.

Modified File(s):
ltp/testcases/network/stress/icmp/multi-diffip/icmp4-multi-diffip01
ltp/testcases/network/stress/ns-tools/killall_icmp_traffic
ltp/testcases/network/stress/ns-tools/killall_tcp_traffic
ltp/testcases/network/stress/tcp/multi-diffip/tcp4-multi-diffip01

42) Log Message:
Addition of Initial set of Process Event Connectors by Li Zefan. Process event connector is a netlink connector that reports process events to userspace, and currently we have 5 kinds of process events, i.e. fork, exit, exec, uid, gid. There are total 5 test cases to test its functionality. But the test is not run by default, because I don't find a way to decide whether the underlying kernel supports this feather or not. Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>.

Added File(s):
ltp/runtest/connectors
ltp/testcases/kernel/connectors/Makefile
ltp/testcases/kernel/connectors/pec/Makefile
ltp/testcases/kernel/connectors/pec/README
ltp/testcases/kernel/connectors/pec/event_generator.c
ltp/testcases/kernel/connectors/pec/pec_listener.c
ltp/testcases/kernel/connectors/pec/run_pec_test

43) Log Message:
Here it is. Based on my last patch.
- building failure on 2.6.16 should be fixed
- fix "make install" if kernel version < 2.6.15
- abort tests if kernel version < 2.6.15
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>.

Modified File(s):
ltp/runtest/connectors
ltp/testcases/kernel/connectors/Makefile
ltp/testcases/kernel/connectors/pec/Makefile
ltp/testcases/kernel/connectors/pec/pec_listener.c

Added File(s):
ltp/testcases/kernel/connectors/connector_test.sh

44) Log Message:
This was ported from the Crackerjack Project by Masatake YAMATO <yamato@redhat.com>.

Modified Files:
ltp/runtest/syscalls

Added Files:
ltp/testcases/kernel/syscalls/io_cancel/Makefile
ltp/testcases/kernel/syscalls/io_cancel/io_cancel01.c
ltp/testcases/kernel/syscalls/io_cancel/run-io_cancel.sh

45) Log Message:
I'd like to use the mechanism you introduced in io_* testcases. So I've made 'io_cancel' string in the script and Makefile a variable to avoid mistake. I made the patch from testcases/kernel/syscalls/io_cancel/Makefile, not from ltp/testcases/kernel/syscalls/io_cancel/Makefile. Is this acceptable. CVS reports like testcases/kernel/syscalls/io_cancel/Makefile. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/io_cancel/Makefile
ltp/testcases/kernel/syscalls/io_cancel/run-io_cancel.sh

46) Log Message:
hackbench tests the Linux scheduler. Initial test was written by Rusty Russell <rusty@rustcorp.com.au>. Later modified by Pierre Peiffer <pierre.peiffer@bull.net>, Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>, "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, Nathan Lynch <ntl@pobox.com> and others. Included in LTP by Subrata Modak<subrata@linux.vnet.ibm.com>, after Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>.

Modified Files:
ltp/runtest/sched
ltp/testcases/kernel/sched/Makefile

Added Files:
ltp/testcases/kernel/sched/cfs-scheduler/Makefile
ltp/testcases/kernel/sched/cfs-scheduler/hackbench.c

47) Log Message:
I am proposing with the joined patch to allow the suite to be able the run the previous rpc tests (called now basic_tests). It needs to resolve some issues in the new "tirpc part" before allowing  the suite to launch it again. Le Rouzic <aime.le-rouzic@bull.net>.

Modified File(s):
ltp/doc/testcases/network.txt
ltp/runtest/rpc
ltp/runtest/stress.part3

48) Log Message:
Few Changes to ttype value.

Modified File(s):
ltp/testcases/kernel/syscalls/timerfd/timerfd01.c

49) Log Message:
Changes to fix Build, Install and run on non-supported architectures.

Added Files:
ltp/testcases/kernel/syscalls/utimensat/check_for_utimensat_support.c
Modified Files:
ltp/testcases/kernel/syscalls/utimensat/Makefile
ltp/testcases/kernel/syscalls/utimensat/utimensat01.c
ltp/testcases/kernel/syscalls/utimensat/utimensat_tests.sh

50) Log Message:
Fixing the run on supported kernels.

Modified File(s):
ltp/testscripts/test_fs_bind.sh

--=-tUPlhz5SWdLwwgcPqaeE--

