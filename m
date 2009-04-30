Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbZD3QAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbZD3QAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbZD3P7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:59:44 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37182 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbZD3P7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:59:41 -0400
Subject: [ANNOUNCE] The Linux Test Project has been Released for APRIL 2009
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mimi Zohar <zohar@us.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Tejun Heo <tj@kernel.org>, Fan He <fhe@novell.com>,
       Francesco Rundo <francesco.rundo@st.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, Ying Han <yinghan@google.com>,
       CAI Qian <caiqian@cclom.cn>, Christian Kujau <lists@nerdbynature.de>,
       poornima nayak <mpnayak@linux.vnet.ibm.com>,
       =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Guo Hongruan <guo.hongruan@gulessoft.com>, Jens Axboe <axboe@kernel.dk>,
       "M. Koehrer" <mathias_koehrer@arcor.de>,
       Maxin John <maxin.john@gmail.com>, Manas K Nayak <maknayak@in.ibm.com>,
       Jiri Palecek <jpalecek@web.de>,
       Dmitry Guryanov <dguryanov@parallels.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Michal Simek <monstr@monstr.eu>, Serge Hallyn <serue@us.ibm.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Content-Type: multipart/mixed; boundary="=-BvmyGYQPSTeeXAedVyda"
Organization: IBM
Date: Thu, 30 Apr 2009 21:29:00 +0530
Message-Id: <1241107142.6751.1.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BvmyGYQPSTeeXAedVyda
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Dear All,

The Linux Test Project test suite has been released for the month of
APRIL 2009. Please see ltp/INSTALL file carefully, as, there has been
multiple changes for building/installing the test suite.

The latest version of the test-suite contains 3000+ tests for the Linux
OS and can be found at:
http://ltp.sourceforge.net/,
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.

========================
APRIL 2009 Highlights:
========================
* Addition of INTEGRITY MEASUREMENT ARCHITECTURE tests,
* Addition of Benchmark Test to compare Per_Cpu_Atomic_Operations vs
Interrupt_Disabling,
* Addition of Per CPU Allocator test,
* Addition of Simple PERFORMANCE COUNTER tests,
* Addition of Software and Hardware PERFORMANCE COUNTERS verification
tests,
* Addition of mmap() corruption check test,
* Addition of syscall tests - splice02, clock_nanosleep2_01 and
cacheflush01,
* Addition of sched_smt_power_savings test in PM,
* Addition of CGROUP Regression tests,
* Addition of CPUSET tests,
* Addition of CAPBOUND Security tests,
* Fixes for numerous other tests,
------------------------------

==============================
APRIL 2009 LTP Contributors:
==============================
* Mimi Zohar,
* Mathieu Desnoyers,
* Tejun Heo,
* Fan He,
* Francesco Rundo,
* Ingo Molnar,
* Paul Mackerras,
* Ying Han,
* CAI Qian,
* Christian Kujau,
* Poornima Nayak,
* Márton Németh,
* Guo Hongruan,
* Jens Axboe,
* M. Koehrer,
* Maxin John,
* Manas K Nayak,
* Jiri Palecek,
* Dmitry Guryanov,
* Li Zefan,
* Miao Xie,
* Michal Simek,
* Serge Hallyn,
* Dave Kleikamp,
------------------------------

==============================
Note(s) from the Maintainer:
==============================
We saw huge no. of new tests been added this month. And i hope the trend
will continue. Apart from that i will soon introduce some fixes as a
fallout of my Paper work at OLS 2009.

Our web site also contains other information such as:
- A Linux test tools matrix
- Technical papers
- How To's on Linux testing
- Code coverage analysis tool.

We would encourage the community to post results to
ltp-results@lists.sf.net,
patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382 (for
New Bug(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382 (for
New Patch(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382 (for
New Feature Request(s))

Happy testing, 
Regards-- 
Subrata,

--=-BvmyGYQPSTeeXAedVyda
Content-Disposition: attachment; filename=April-2009_Changelog.txt
Content-Type: text/plain; name=April-2009_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

1) Log Message:
This patch adds Integrity Measurement Architecture(IMA) testing support:
Changes:
- updated README
- add test for existence of openssl-devel (m4/ltp-crypto.m4)
- add support for finding an audit message in different log files
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>.

Modified Files:
ltp/config.mk.in
ltp/configure.ac
ltp/testcases/kernel/security/Makefile
Added Files:
ltp/m4/ltp-crypto.m4
ltp/runtest/ima
ltp/testcases/kernel/security/integrity/Makefile
ltp/testcases/kernel/security/integrity/ima/Makefile
ltp/testcases/kernel/security/integrity/ima/README
ltp/testcases/kernel/security/integrity/ima/policy/Makefile
ltp/testcases/kernel/security/integrity/ima/policy/measure.policy
ltp/testcases/kernel/security/integrity/ima/policy/measure.policy-invalid
ltp/testcases/kernel/security/integrity/ima/src/Makefile
ltp/testcases/kernel/security/integrity/ima/src/ima_boot_aggregate.c
ltp/testcases/kernel/security/integrity/ima/src/ima_measure.c
ltp/testcases/kernel/security/integrity/ima/src/ima_mmap.c
ltp/testcases/kernel/security/integrity/ima/tests/Makefile
ltp/testcases/kernel/security/integrity/ima/tests/ima_measurements.sh
ltp/testcases/kernel/security/integrity/ima/tests/ima_policy.sh
ltp/testcases/kernel/security/integrity/ima/tests/ima_setup.sh
ltp/testcases/kernel/security/integrity/ima/tests/ima_tpm.sh
ltp/testcases/kernel/security/integrity/ima/tests/ima_violations.sh

2) Log Message:
Addition of per_cpu_atomic_operations_vs_interrupt_disabling_module test to=
 LTP. Signed-Off-By: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>.

Added Files:
ltp/testcases/kernel/device-drivers/misc_modules/per_cpu_atomic_operations_=
vs_interrupt_disabling_module/Makefile
ltp/testcases/kernel/device-drivers/misc_modules/per_cpu_atomic_operations_=
vs_interrupt_disabling_module/test-cmpxchg-nolock.c

3) Log Message:
Module to test Per CPU Allocator. Signed-Off-By: Tejun Heo <tj@kernel.org>.

Added Files:
ltp/testcases/kernel/device-drivers/misc_modules/per_cpu_allocator_module/M=
akefile
ltp/testcases/kernel/device-drivers/misc_modules/per_cpu_allocator_module/t=
est_per_cpu_allocator_module.c

4) Log Message:
Patch for fixing the testcase's segment fault. Signed-Off-By: Fan He <fhe@n=
ovell.com>.

Modified File(s):
ltp/testcases/open_posix_testsuite/conformance/interfaces/timer_gettime/spe=
culative/6-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/timer_settime/spe=
culative/12-1.c

5) Log Message:
Extended the summary info to the case of LTP cross-built i.e. running on di=
fferent arch with respect to the host. Moreover, a more detailed summary ab=
out LTP test results has been added. Signed-off-by: Francesco Rundo <france=
sco.rundo@st.com>.

Modified File(s):
ltp/tools/genhtml.pl

6) Log Message:
Add Simple Test for PERFORMANCE COUNTER in Linux. Signed-Off-By: Ingo Molna=
r <mingo@elte.hu>. Ported-To-And-Tested-On-LTP-By: Subrata Modak <subrata@l=
inux.vnet.ibm.com>.

Modified Files:
ltp/runalltests.sh
Added Files:
ltp/runtest/perfcounters
ltp/testcases/kernel/performance_counters/Makefile
ltp/testcases/kernel/performance_counters/performance_counter01.c

7) Log Message:
Add Test for Software and Hardware PERFORMANCE COUNTERS verification in Lin=
ux. Signed-Off-By: Paul Mackerras <paulus@samba.org>. Ported-To-And-Tested-=
On-LTP-By: Subrata Modak <subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/perfcounters
Added Files:
ltp/testcases/kernel/performance_counters/performance_counter02.c

8) Log Message:
Add Test for Checking mmap() corruption. Signed-Off-By: Ying Han <yinghan@g=
oogle.com>. Ported-To-And-Tested-On-LTP-By: Subrata Modak <subrata@linux.vn=
et.ibm.com>.

Modified Files:
ltp/runtest/stress.part1
Added Files:
ltp/testcases/kernel/mem/mmapstress/mmap-corruption01.c

9) Log Message:
Growfiles: Fix Test Failures. See: http://marc.info/?t=3D123866461100001&r=
=3D1&w=3D2&n=3D2, for more info. Signed-Off-By: CAI Qian <caiqian@cclom.cn>=
.

Modified File(s):
ltp/lib/Makefile
ltp/testcases/kernel/fs/doio/growfiles.c

10) Log Message:
While running the latest LTP testsuite (CVS checkout), some tests failed du=
e to small errors in the testscripts. I've attached two diffs for both test=
cases/kernel/syscalls/utimensat/utimensat_tests.sh and testcases/kernel/sys=
calls/ioctl/test_ioctl. Signed-Off-By: Christian Kujau <lists@nerdbynature.=
de>.

Modified File(s):
ltp/testcases/kernel/syscalls/ioctl/test_ioctl
ltp/testcases/kernel/syscalls/utimensat/utimensat_tests.sh

11) Log Message:
Patch to integrate sched_smt cpu consolidation testcase to LTP. Signed-off-=
by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/power_management/pm_include.sh
ltp/testcases/kernel/power_management/runpwtests.sh

12) Log Message:
This is v4l-test 0.11 patch for LTP. Changes:
 - Test cases added for VIDIOC_G_OUTPUT, VIDIOC_S_OUTPUT, VIDIOC_G_FMT, VID=
IOC_G_SLICED_VBI_CAP, VIDIOC_QUERYMENU;
 - Cleaned up ret and errno variable names;
 - Separated the NULL parameter test cases to a separated testsuite and rew=
orked most of the NULL parameter test cases;
 - Added camera enabling through /sys/devices/platform/eeepc/camera;
 - Added results page to documentation;
 - Follow kernel API changes in video_dummy.ko
Signed-off-by: M=C3=A1rton N=C3=A9meth <nm127@freemail.hu>.

Modified Files:
ltp/testcases/kernel/device-drivers/v4l/kernel_space/video_dummy.c
ltp/testcases/kernel/device-drivers/v4l/user_space/Makefile
ltp/testcases/kernel/device-drivers/v4l/user_space/README
ltp/testcases/kernel/device-drivers/v4l/user_space/dev_video.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_AUDIO.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_AUDOUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_CROP.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_CROPCAP.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_CTRL.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMAUDIO.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMAUDOUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMINPUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMOUTPUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMSTD.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUM_FMT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_FREQUENCY.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_FREQUENCY.h
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_INPUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_INPUT.h
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_LOG_STATUS.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_MODULATOR.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_PARM.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_PRIORITY.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYCAP.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYCTRL.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYSTD.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_STD.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_TUNER.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_invalid_ioctl.c
ltp/testcases/kernel/device-drivers/v4l/user_space/v4l2_test.c
ltp/testcases/kernel/device-drivers/v4l/user_space/doc/index.html
Added Files:
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_FMT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_FMT.h
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_G_SLICED_VBI=
_CAP.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_G_SLICED_VBI=
_CAP.h
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_OUTPUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_OUTPUT.h
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYMENU.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYMENU.h
ltp/testcases/kernel/device-drivers/v4l/user_space/doc/results.html

13) Log Message:
Patch for fixing the openposix_getoverrun_speculative_6_1 testcase's segmen=
t fault. Signed-Off-By: Fan He <fhe@novell.com>.

Modified File(s):
ltp/testcases/open_posix_testsuite/conformance/interfaces/timer_getoverrun/=
speculative/6-1.c

14) Log Message:
Patch for fixing the openposix_timer_delete_speculative_5_1 testcase's segm=
ent fault. Signed-Off-By: Fan He <fhe@novell.com>.

Modified File(s):
ltp/testcases/open_posix_testsuite/conformance/interfaces/timer_delete/spec=
ulative/5-1.c

15) Log Message:
I am not sure what kinds of IO and wait methods are available on uClinux, b=
ut by looking at the code in tlibio.h, the following method seems not suppo=
rted there. So whenever LIO_IO_SYNCP was chosen as the random IO method, it=
 will skip the above code and failback to "No I/O method chosen". Can you t=
ry the following patch to see if it fixes the problem? It drops LIO_IO_SYNC=
P as an avaliable method for uClinux, and also narrows down the wait method=
s since it does not support async IO there. I'd hope someone knew better th=
an me about uClinux to review this patch. Signed-off-by: CAI Qian <caiqian@=
cclom.cn>.

Modified File(s):
ltp/include/tlibio.h

16) Log Message:
Fix clone07 bug. Signed-Off-By: Guo Hongruan <guo.hongruan@gulessoft.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/clone/clone07.c

17) Log Message:
Addition of splice02 test for splice() syscall. Original-Author: Jens Axboe=
 <axboe@kernel.dk>, Ported-To-LTP:By: Manas K Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/splice/splice02.c

18) Log Message:
Addition of clock_nanosleep2_01 test for clock_nanosleep2() syscall. Origin=
al-Author: M. Koehrer <mathias_koehrer@arcor.de>, Ported-To-LTP-By: Manas K=
 Nayak <maknayak@in.ibm.com>,

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/clock_nanosleep2/Makefile
ltp/testcases/kernel/syscalls/clock_nanosleep2/clock_nanosleep2_01.c

19) Log Message:
Addition of cacheflush01 test for cacheflush() syscall. Original-Author: Ma=
xin John <maxin.john@gmail.com>, Ported-To-LTP-By: Manas K Nayak <maknayak@=
in.ibm.com>,

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/cacheflush/Makefile
ltp/testcases/kernel/syscalls/cacheflush/cacheflush01.c

20) Log Message:
Fix mount02 and mount03. Signed-Off-By: Guo Hongruan <guo.hongruan@gulessof=
t.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/mount/mount02.c
ltp/testcases/kernel/syscalls/mount/mount03.c

21) Log Message:
How many loops should setuid04 run test case using "setuid04 -i 2"? It shou=
ld be 2 but in fact, it is 3, This patch solves this problem. Hoppe it is u=
seful. Thanks a lot!. Signed-Off-By: Guo Hongruan <guo.hongruan@gulessoft.c=
om>.

Modified File(s):
ltp/testcases/kernel/syscalls/setuid/setuid04.c

22) Log Message:
Rohit verma <rohit.170309@gmail.com> wrote: There is a change in compilatio=
n mechanism in LTP from Feb 09 distribution.The previous Make mechanism did=
 not provide any optimization while compiling the fork05 test program and t=
he test used to Pass . However the newer Makefile uses optimization level 2=
 while compiling, if this file is executed the test case fails. CAI Qian <c=
aiqian@cclom.cn> replied: This is definitely a case. I can reproduce it on =
Fedora 10, so I have created a bug of it, and copied the author Ulrich Drep=
per, https://bugzilla.redhat.com/show_bug.cgi?id=3D495296. Ulrich Drepper h=
as pointed out in the above bug report that this failure was due to incorre=
ct test code. The test code isn't correct.  The compiler cannot look inside=
 the asm statements in main() and see that they are really necessary.  Base=
d on the information given the compiler can drop some of them. Change all a=
sms in main from asm(...) to asm volatile(...), and the code works fine. Wi=
th the following patch, it works fine with and without compilation optimiza=
tion. Signed-off-by: CAI Qian <caiqian@cclom.cn>.

Modified Files:
ltp/testcases/kernel/syscalls/fork/fork05.c

23) Log Message:
Fix from CAI Qian <caiqian@cclom.cn>.

Modified Files:
ltp/testcases/network/lib6/runcc.c

24) Log Message:
It turns out that -s option does not has any effect for binutils ar, which =
makes related test cases invalid in ar01 test. Nick Clifton replied in the =
bug report, https://bugzilla.redhat.com/show_bug.cgi?id=3D490797. It does m=
ake a difference on some versions of the ar program, notably those on some =
Unix and Solaris systems.  These versions of ar do not automatically added =
a symbol index when the archive is created. But the binutils ar automatical=
ly adds a symbol index when an archive is created.  So the -s option is sup=
ported mainly for backwards compatibility with these other versions of ar. =
Signed-off-by: CAI Qian <caiqian@cclom.cn>.

Modified Files:
ltp/testcases/commands/ade/ar/ar01

25) Log Message:
The library file in powermanagement testcase is modified to support sched_m=
c=3D2 testing. Wrote a another function to generate load in the system thro=
ugh make -j x. Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/lib/sched_mc.py

26) Log Message:
CPU consolidation testcase is modified such that workload is not passed as =
input to the testcase. Based on sched_mc input corresponding workload is tr=
iggered. Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/cpu_consolidation.py

27) Log Message:
Master script of Powermanagement testcase is modified to invoke cpu_consoli=
dation testcase without workload. Restructured cpu_consolidation testcase w=
ithin a loop. Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/runpwtests.sh

28) Log Message:
This testcase test sched_smt_power_saving interface with valid and inavlid =
values. Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Added Files:
ltp/testcases/kernel/power_management/test_sched_smt.sh

29) Log Message:
Modifed test_sched_mc interface testing testcase to use reusable function. =
Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/test_sched_mc.sh

30) Log Message:
The test_dma_thread_diotest contains an unnecessary bashism. This patch fix=
es that. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified File(s):
ltp/testcases/kernel/io/direct_io/test_dma_thread_diotest7.sh

31) Log Message:
Make fs/quota_remount_test01 more POSIX-shell friendly. Signed-off-by: Jiri=
 Palecek <jpalecek@web.de>.

Modified File(s):
ltp/testcases/kernel/fs/quota_remount/quota_remount_test01.sh

32) Log Message:
First, there was bug in test - it used seconds part of struct timespec stru=
cture, because total_sec was 5 from previous loop, and 1..4 millions of nan=
oseconds in addition to these 5 seconds did nothing in test result, checkin=
g sleep time for correctness also used total_sec. Also pselect takes struct=
 timespec as its argument, not struct timeval, now code in test uses struct=
 timeval as argument of pselect and suppose second field of this structure =
is microseconds instead of nanoseconds. Let's fix this part of test - I sug=
gest to set nanoseconds to 1e8 ... 4e8 with step 1e8 and check sleep time d=
iffers from expected value no more than 10% of it. Signed-Off-By: Dmitry Gu=
ryanov <dguryanov@parallels.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/pselect/pselect01.c

33) Log Message:
This is the patch of the v4l-test 0.12 for LTP. Changes: Test cases added f=
or VIDIOC_S_FMT; NULL parameter test suite split to read only, write only a=
nd write/read ioctl suite; More verbose debug output in VIDIOC_S_FREQUENCY =
and in some other test cases; More strict check added for strings in differ=
ent test cases. Signed-off-by: M=C3=A1rton N=C3=A9meth <nm127@freemail.hu>.

Modified File(s):
ltp/testcases/kernel/device-drivers/v4l/user_space/README
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_AUDIO.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_AUDOUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMAUDIO.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMAUDOUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMINPUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMOUTPUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMSTD.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUM_FMT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_FMT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_FMT.h
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_FREQUENCY.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_MODULATOR.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYCAP.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYCTRL.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYMENU.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_STD.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_TUNER.c
ltp/testcases/kernel/device-drivers/v4l/user_space/v4l2_test.c
ltp/testcases/kernel/device-drivers/v4l/user_space/doc/index.html
ltp/testcases/kernel/device-drivers/v4l/user_space/doc/results.html

34) Log Message:
Jiri Palecek <jpalecek@web.de> wrote: While running the selinux tests, I wa=
s contemplating the way the $SELINUXTMPDIR is created. It seems to me that =
creating it in each test individually would allow running the tests in para=
llel, make some hacks needed to prevent interference of the tests unnecessa=
ry, allow the tests to be run directly from ltpmenu et al., and wouldn't ad=
d much more code. What do you think about this? Signed-off-by: Jiri Palecek=
 <jpalecek@web.de>.
"Serge E. Hallyn" <serue@us.ibm.com> replied:
If the motivation is to support multiple concurrent ltp runs, wouldn't it b=
e better to have selinux-testsuite/tests/runtest.sh set/export SELINUXTMPDI=
R to a per-run tempdir? Even as simple as /tmp/selinux-$pid. Well, and test=
scripts/test_selinux.sh I guess. Hmm, no, bc at that level you can't easily=
 support multiple policy module loads anyway. Never mind.
Jiri Palecek <jpalecek@web.de> replied back: No, the motivation was mostly =
to allow running these tests directly from PAN, without any supporting scri=
pts. The ability to run the tests concurrently is just a pleasant bonus. I =
chose this way, because I find the needed changes pretty small.=20
"Serge E. Hallyn" <serue@us.ibm.com> finally replied: Yeah - seems like a g=
ood idea. If the directories sometimes don't get deleted, then you might he=
lp out the admin by giving the directories easy to spot names so they can m=
anually clean up...  i.e. use mktemp -d /tmp/ltpselinuxXXXX or maybe even b=
etter mkdir -p /tmp/ltpselinux; mktemp -d -p /tmp/ltpselinux.

Modified File(s):
ltp/testcases/kernel/security/selinux-testsuite/tests/bounds/selinux_bounds=
.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/capable_file/selinux_=
capable_file.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/capable_sys/selinux_c=
apable_sys.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/entrypoint/selinux_en=
trypoint.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/execute_no_trans/seli=
nux_execute_no_trans.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/fdreceive/selinux_fdr=
eceive.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/file/selinux_file.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/inherit/selinux_inher=
it.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/ioctl/selinux_ioctl.s=
h
ltp/testcases/kernel/security/selinux-testsuite/tests/link/selinux_link.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/mkdir/selinux_mkdir.s=
h
ltp/testcases/kernel/security/selinux-testsuite/tests/open/selinux_open.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/readlink/selinux_read=
link.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/relabel/selinux_relab=
el.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/rename/selinux_rename=
.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/rxdir/selinux_rxdir.s=
h
ltp/testcases/kernel/security/selinux-testsuite/tests/setattr/selinux_setat=
tr.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/stat/selinux_stat.sh

35) Log Message:
I have been trying to run the selinux tests on Debian and discovered a smal=
l flaw. The test was using a return value variable which wasn't set by the =
test. I've coma across another strange (at least to me) fact - when you exe=
cute a program without path, it is searched for in $PATH. However, if the p=
rogram is in one directory if $PATH and selinux rejects to run the file, th=
e following directories in $PATH are search, and the call can succeed. Is t=
his behavior planned? I know it can't tamper the security of selinux, but i=
t can lead to surprising results. Also, I've found some uses of macros not =
present in Debian's refpolicy. Should I send a patch for them? Signed-off-b=
y: Jiri Palecek <jpalecek@web.de>.

Modified File(s):
ltp/testcases/kernel/security/selinux-testsuite/tests/entrypoint/selinux_en=
trypoint.sh

36) Log Message:
Add cgroup regression tests to LTP: Those testcases can reproduce bugs we f=
ound in cgroups, and is useful to track future regressions. Note: this test=
 may crash the system with older kernels, so it is disabled for kernels old=
er than 2.6.29. Another note: getdelays.c is linux-2.6/Documentation/accoun=
ting/getdelays.c. How to run this test:     # runltp -f controllers
Result:
cgroup_regression_test    1  PASS  :  no kernel bug was found
cgroup_regression_test    2  PASS  :  notify_on_release is inherited
cgroup_regression_test    3  PASS  :  no kernel bug was found
cgroup_regression_test    4  PASS  :  no lockdep BUG was found
cgroup_regression_test    5  PASS  :  no kernel bug was found
cgroup_regression_test    6  PASS  :  no kernel bug was found
cgroup_regression_test    7  PASS  :  no kernel bug was found
cgroup_regression_test    8  PASS  :  no kernel bug was found
cgroup_regression_test    9  PASS  :  no kernel warning was found
cgroup_regression_test   10  PASS  :  no kernel warning was found
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>.

Modified Files:
ltp/runtest/controllers
ltp/testcases/kernel/controllers/Makefile
ltp/testcases/kernel/controllers/README
Added Files:
ltp/testcases/kernel/controllers/cgroup/Makefile
ltp/testcases/kernel/controllers/cgroup/README
ltp/testcases/kernel/controllers/cgroup/cgroup_regression_test.sh
ltp/testcases/kernel/controllers/cgroup/fork_processes.c
ltp/testcases/kernel/controllers/cgroup/getdelays.c
ltp/testcases/kernel/controllers/cgroup/test_10_1.sh
ltp/testcases/kernel/controllers/cgroup/test_10_2.sh
ltp/testcases/kernel/controllers/cgroup/test_3_1.sh
ltp/testcases/kernel/controllers/cgroup/test_3_2.sh
ltp/testcases/kernel/controllers/cgroup/test_6_1.sh
ltp/testcases/kernel/controllers/cgroup/test_6_2.c
ltp/testcases/kernel/controllers/cgroup/test_9_1.sh
ltp/testcases/kernel/controllers/cgroup/test_9_2.sh

37) Log Message:
Test suite for cpuset: This is the test suite for the basis operation test =
and part functionality test of cpuset. It contains adding/removing cpus/mem=
s test, setting flags test, exclusive function test, hierarchy relation tes=
t, inherit relation test and cpuset VS syscall test. More testcases will be=
 added in future. Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/controllers/Makefile
ltp/testcases/kernel/controllers/README
ltp/testcases/kernel/controllers/test_controllers.sh
ltp/testcases/kernel/controllers/testplan.txt
Added Files:
ltp/testcases/kernel/controllers/cpuset/Makefile
ltp/testcases/kernel/controllers/cpuset/README
ltp/testcases/kernel/controllers/cpuset/run_cpuset_test.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_base_ops_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_base_ops_test/cpuset_base_op=
s_testset.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_exclusive_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_exclusive_test/cpuset_exclus=
ive_test.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_hierarchy_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_hierarchy_test/cpuset_hierar=
chy_test.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_inherit_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_inherit_test/cpuset_inherit_=
testset.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/cpuset_funcs.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_syscall_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_syscall_test/cpuset_syscall_=
test.c
ltp/testcases/kernel/controllers/cpuset/cpuset_syscall_test/cpuset_syscall_=
testset.sh

38) Log Message:
While running the su01 test on Debian, I encountered a different error mess=
age on changing the password and giving a wrong old password. I guess the e=
rror message is actually OK, so I suggest to add it to the possible success=
ful outcomes. Signed-off-by: Jiri Palecek <jpalecek@web.de>.=20

Modified Files:
ltp/testcases/commands/su/su01_s1

39) Log Message:
Fix running of the selinux tests: while running the ltp selinux tests on De=
bian, I found some problems: 1) the testdomain attribute cannot have setcur=
rent permission to itself. This is because in Debian refpolicy, only domain=
s with attribute set_curr_context can have setcurrent permission on own pro=
cesses (otherwise, it's forbidden by neverallow). And AFAIK, it's impossibl=
e to specify that domains having attribute testdomain also have attribute s=
et_curr_context. Moreover, I found only two tests (dyntrans and dyntrace) t=
hat actually need it so far, so I'm not convinced it has to be granted glob=
ally. 2) the testscripts (eg. selinux_file.sh) have the test_file_t context=
, but they are to be run as sysadm_t. Sysadm_t therefore needs execute_no_t=
rans permission on the test files. Please correct me if I'm wrong. - allow =
sysadm_t execute_no_trans on test_file_t to allow him to run the test shell=
 scripts - get rid of setexec permission for testdomain, it conflicts with =
refpolicy and AFAIK is unneeded. Signed-off-by: Jiri Palecek <jpalecek@web.=
de>.

Modified Files:
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_global.te

40) Log Message:

README: update kernel config for cgroup testing: lockdep is needed in one o=
f the testcases in cgroup regression test. Signed-off-by: Li Zefan <lizf@cn=
.fujitsu.com>.

Modified Files:
ltp/README

41) Log Message:
Fix fsync02 usage on filesystems which have undefined amount of free space:=
 "Fields that are undefined for a particular file system are set to 0". Not=
e that if it's ramfs or tmpfs with -o nr_blocks=3D0, there is no such thing=
 as "amount of free space", reserved for root or not. - Al Viro. Signed-off=
-by: Michal Simek <monstr@monstr.eu>.

Modified Files:
ltp/testcases/kernel/syscalls/fsync/fsync02.c

42) Log Message:
Delete the change_owner binary, as it is an insecure suid root binary; rewr=
ite tests that use it: This patch is based on Jiri's change_owner patch. I =
removed references in runtest/syscalls and fix some coding style violations=
. Signed-off-by: Michal Simek <monstr@monstr.eu>.

Modified Files:
ltp/runtest/syscalls
ltp/testcases/kernel/syscalls/chmod/Makefile
ltp/testcases/kernel/syscalls/chmod/chmod05.c
ltp/testcases/kernel/syscalls/chmod/chmod06.c
ltp/testcases/kernel/syscalls/chown/Makefile
ltp/testcases/kernel/syscalls/chown/chown03.c
ltp/testcases/kernel/syscalls/chown/chown04.c
ltp/testcases/kernel/syscalls/fchmod/Makefile
ltp/testcases/kernel/syscalls/fchmod/fchmod05.c
ltp/testcases/kernel/syscalls/fchmod/fchmod06.c
ltp/testcases/kernel/syscalls/fchown/Makefile
ltp/testcases/kernel/syscalls/fchown/fchown03.c
ltp/testcases/kernel/syscalls/fchown/fchown04.c

43) Log Message:
The attached patch fixes this bug. This is the bug of the kernel. The follo=
wing patch has fixed the bug.
commit af76aba00fdcfb21535c9f9872245d14097a4561
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:05:11 2009 -0600
    cpumask: fix seq_bitmap_*() functions.
     1) seq_bitmap_list() should take a const.
     2) All the seq_bitmap should use cpumask_bits().
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
But after applying this patch, Case 5 and 6 still failed. It is because the=
 max size of CPUSET in the glibc is 1024, but the  max size of your kernel =
is 4096, when we invoke the sched_getaffinity, the kernel will check whethe=
r the size of mask passed into the function is >=3D the size of the mask in=
 the kernel. If not, the function returns -1. So it is not the bug of the t=
esecase. This patch contains two lib files written by Paul Jackson who is e=
x-maintainer of cpuset. These two lib files are used for both this bug fix =
and the testcases that will be added in future. Signed-Off-By: Miao Xie <mi=
aox@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/cpuset_funcs.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_syscall_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_syscall_test/cpuset_syscall_=
test.c
ltp/testcases/kernel/controllers/cpuset/cpuset_syscall_test/cpuset_syscall_=
testset.sh
Added Files:
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/bitmask.h
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/common.h
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/cpuset.h
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/libbitmask.c
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/libcpuset.c

44) Log Message:
Add capability bounding set testcases, to verify the following:
        1. prctl(CAP_BSET_READ, 0..NCAPS) returns 1
        2. prctl(CAP_BSET_READ, -1|NCAPS+1) return -1
        3. prctl(CAP_BSET_DROP, -1|NCAPS+1) returns -1
        4. prctl(CAP_BSET_DROP, 0..NCAPS) returns 1
           4b. prctl(CAP_BSET_READ, N) returns 0 after each unset, 1 for th=
ose not yet removed
        5. fI=3Dempty; N \notin pP; prctl(CAPBSET_DROP, N); setting pI=3DN =
fails
        6. pI=3DN; fI=3DfE=3DN; prctl(CAPBSET_DROP, N); exec(f) - N \in pE
                (or make f setuid-root)
        7. pI=3D0; fI=3DfE=3DN; prctl(CAPBSET_DROP, N); exec(f) - N \notin =
pE
                (or make f setuid-root)
A set of securebits and keepcaps tests have yet to be written (as per an em=
ail I sent a few months ago). Signed-off-by: Serge Hallyn <serue@us.ibm.com=
>.

Modified Files:
ltp/runltp
ltp/testcases/kernel/security/Makefile
Added Files:
ltp/runtest/cap_bounds
ltp/testcases/kernel/security/cap_bound/Makefile
ltp/testcases/kernel/security/cap_bound/cap_bounds_r.c
ltp/testcases/kernel/security/cap_bound/cap_bounds_rw.c
ltp/testcases/kernel/security/cap_bound/cap_bset_inh_bounds.c
ltp/testcases/kernel/security/cap_bound/check_for_libcap.sh
ltp/testcases/kernel/security/cap_bound/check_pe.c
ltp/testcases/kernel/security/cap_bound/dummy.c
ltp/testcases/kernel/security/cap_bound/exec_with_inh.c
ltp/testcases/kernel/security/cap_bound/exec_without_inh.c
ltp/testcases/kernel/security/cap_bound/run_capbounds.sh

45) Log Message:
Exit in testsf_s6 when host lookup fails to prevent segfaults later. Jiri P=
alecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/network/ipv6/sendfile6/testsf_s6.c

46) Log Message:
Fix collateral damage caused by recent coding style cleanups. Signed-off-by=
: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/syscalls/syslog/syslog01
ltp/testcases/kernel/syscalls/syslog/syslog02
ltp/testcases/kernel/syscalls/syslog/syslog03
ltp/testcases/kernel/syscalls/syslog/syslog04
ltp/testcases/kernel/syscalls/syslog/syslog05
ltp/testcases/kernel/syscalls/syslog/syslog06
ltp/testcases/kernel/syscalls/syslog/syslog07
ltp/testcases/kernel/syscalls/syslog/syslog08
ltp/testcases/kernel/syscalls/syslog/syslog09
ltp/testcases/kernel/syscalls/syslog/syslog10

47) Log Message:
This patch is a rewrite of symlinkat and linkat tests aimed to:=20
 - simplify the code
 - cease using the current directory for testfiles
Hope this applies, since I'm sending this from a weekly (er.. monthly) vers=
ion of Opera. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/syscalls/linkat/linkat01.c
ltp/testcases/kernel/syscalls/symlinkat/symlinkat01.c

48) Log Message:
fallocate tests call syscall() incorrectly for 32-bit powerpc. Signed-off-b=
y: Dave Kleikamp <shaggy@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/syscalls/fallocate/fallocate01.c
ltp/testcases/kernel/syscalls/fallocate/fallocate02.c
ltp/testcases/kernel/syscalls/fallocate/fallocate03.c

49) Log Message:
IMA update openssl-devel existence test: Verify the existence of openssl/sh=
a.h not libcrypto, which is included in multiple packages, to determine if =
openssl-devel is installed. Signed-off-by: Mimi Zohar <zohar@us.ibm.com>. A=
cked-by: Serge Hallyn <serue@us.ibm.com>.

Modified File(s):
ltp/m4/ltp-crypto.m4

50) Log Message:
Reverting Jiri Palecek <jpalecek@web.de> patch: <SUBJECT: Fix running of th=
e selinux tests>, as Stephen Smalley <sds@tycho.nsa.gov> objected as: NAK t=
o this one as well - if you look at the commented-out line immediately foll=
owing the setcurrent one, you'll see what you need to do to make this work =
_if_ you aren't following the README instructions in the first place.  sysa=
dm_t one might be valid due to tightening of sysadm_t in more modern refpol=
icy, but just revert the patch for now please and await an ack on future on=
es.

Modified Files:
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_global.te

51) Log Message:
Reverting "Christopher J. PeBenito" <cpebenito@tresys.com> patch: <SUBJECT:=
 LTP SELinux policy error> applied on 02-02-2009, as, Stephen Smalley <sds@=
tycho.nsa.gov> objected as: Subrata - this patch never should have been app=
lied.  Chris said that it was incomplete, and I noted that it conflicted wi=
th Serge's conditionally applied patch.  Please revert this, as it breaks t=
he selinux ltp testsuite and the resulting policy will not build.

Modified Files:
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_capable_file=
.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_capable_net.=
te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_dyntrace.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_dyntrans.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_entrypoint.t=
e
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_execshare.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_exectrace.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_execute_no_t=
rans.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_fdreceive.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_file.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_global.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_inherit.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_ioctl.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_ipc.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_link.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_mkdir.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_open.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_ptrace.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_relabel.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_rename.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_setattr.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_setnice.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_sigkill.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_sysctl.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_task_create.=
te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_task_getpgid=
.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_task_getsche=
d.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_task_getsid.=
te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_task_setpgid=
.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_task_setsche=
d.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_transition.t=
e
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_wait.te

--=-BvmyGYQPSTeeXAedVyda--

