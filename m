Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYCXPhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYCXPhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 11:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYCXPhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 11:37:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45209 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbYCXPhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 11:37:07 -0400
Date: Mon, 24 Mar 2008 08:35:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: errors building 2.6.24.3
Message-Id: <20080324083543.7185a93a.randy.dunlap@oracle.com>
In-Reply-To: <200803241057.00824.gene.heskett@gmail.com>
References: <200803241057.00824.gene.heskett@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008 10:57:00 -0400 Gene Heskett wrote:

> Greetings;
> 
> ------------------
>   INSTALL include/mtd/inftl-user.h
> make[3]: *** No rule to make target 
> `/usr/src/linux-2.6.24.3/include/linux/if_addrlabel.h', needed by 
> `/usr/src/linux-2.6.24.3/usr/include/linux/if_addrlabel.h'.  Stop.
> make[3]: *** Waiting for unfinished jobs....
>   INSTALL include/asm-generic/fcntl.h
>   MKDIR   include/video
>   INSTALL include/asm/bootparam.h
> make[2]: *** [linux] Error 2
> make[2]: *** Waiting for unfinished jobs....
>   INSTALL include/mtd/jffs2-user.h
>   INSTALL include/rdma/ib_user_mad.h
>   INSTALL include/asm/debugreg.h
>   INSTALL include/sound/asound_fm.h
>   INSTALL include/asm-generic/ioctl.h
>   UNIFDEF include/video/edid.h
>   INSTALL include/mtd/mtd-abi.h
>   INSTALL include/asm/ldt.h
>   INSTALL include/sound/hdsp.h
>   INSTALL include/asm-generic/mman.h
>   INSTALL include/sound/hdspm.h
>   INSTALL include/mtd/mtd-user.h
>   INSTALL include/asm/msr-index.h
>   UNIFDEF include/video/sisfb.h
>   INSTALL include/asm/prctl.h
>   INSTALL include/asm-generic/poll.h
>   INSTALL include/mtd/nftl-user.h
>   INSTALL include/asm/ptrace-abi.h
>   UNIFDEF include/video/uvesafb.h
>   INSTALL include/sound/sfnt_info.h
>   INSTALL include/mtd/ubi-header.h
>   INSTALL include/asm/sigcontext32.h
>   INSTALL include/mtd/ubi-user.h
>   INSTALL include/asm-generic/signal.h
>   INSTALL include/sound/sscape_ioctl.h
>   INSTALL include/asm/ucontext.h
>   INSTALL include/asm-generic/statfs.h
>   UNIFDEF include/sound/asequencer.h
>   INSTALL include/asm/vsyscall32.h
>   UNIFDEF include/asm-generic/resource.h
>   UNIFDEF include/sound/asound.h
>   UNIFDEF include/asm-generic/siginfo.h
>   UNIFDEF include/sound/emu10k1.h
>   UNIFDEF include/asm/a.out.h
>   UNIFDEF include/asm/auxvec.h
>   UNIFDEF include/sound/sb16_csp.h
>   UNIFDEF include/asm/byteorder.h
>   UNIFDEF include/asm/e820.h
>   UNIFDEF include/asm/elf.h
>   UNIFDEF include/asm/errno.h
>   UNIFDEF include/asm/fcntl.h
>   UNIFDEF include/asm/ioctl.h
>   UNIFDEF include/asm/ioctls.h
>   UNIFDEF include/asm/ipcbuf.h
>   UNIFDEF include/asm/ist.h
>   UNIFDEF include/asm/mce.h
>   UNIFDEF include/asm/mman.h
>   UNIFDEF include/asm/msgbuf.h
>   UNIFDEF include/asm/msr.h
>   UNIFDEF include/asm/mtrr.h
>   UNIFDEF include/asm/page.h
>   UNIFDEF include/asm/page_32.h
>   UNIFDEF include/asm/page_64.h
>   UNIFDEF include/asm/param.h
>   UNIFDEF include/asm/poll.h
>   UNIFDEF include/asm/posix_types.h
>   UNIFDEF include/asm/posix_types_32.h
>   UNIFDEF include/asm/posix_types_64.h
>   UNIFDEF include/asm/ptrace.h
>   UNIFDEF include/asm/resource.h
>   UNIFDEF include/asm/sembuf.h
>   UNIFDEF include/asm/setup.h
>   UNIFDEF include/asm/shmbuf.h
>   UNIFDEF include/asm/sigcontext.h
>   UNIFDEF include/asm/siginfo.h
>   UNIFDEF include/asm/signal.h
>   UNIFDEF include/asm/socket.h
>   UNIFDEF include/asm/sockios.h
>   UNIFDEF include/asm/stat.h
>   UNIFDEF include/asm/statfs.h
>   UNIFDEF include/asm/termbits.h
>   UNIFDEF include/asm/termios.h
>   UNIFDEF include/asm/types.h
>   UNIFDEF include/asm/unistd.h
>   UNIFDEF include/asm/unistd_32.h
>   UNIFDEF include/asm/unistd_64.h
>   UNIFDEF include/asm/user.h
>   UNIFDEF include/asm/user_32.h
>   UNIFDEF include/asm/user_64.h
>   UNIFDEF include/asm/vm86.h
>   UNIFDEF include/asm/vsyscall.h
> make[1]: *** [headers_install] Error 2
> make: *** [vmlinux] Error 2
> mv: cannot stat `/boot/initrd-2.6.24.3.img': No such file or directory
> cp: cannot stat `initrd-2.6.24.3.img': No such file or directory
> 
> real    7m29.649s
> user    5m39.719s
> sys     0m48.512s
> 
> These last 8 lines are from my 'makeit' script.
> 
> What do I have miss-configured?

This was a merge error in 2.6.24.3.  The next stable release
will have it fixed/reverted.  See http://lkml.org/lkml/2008/3/21/450
for the patch.

---
~Randy
