Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbYADLhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbYADLhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYADLhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:37:37 -0500
Received: from kuber.nabble.com ([216.139.236.158]:54426 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYADLhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:37:36 -0500
Message-ID: <14614652.post@talk.nabble.com>
Date: Fri, 4 Jan 2008 03:37:35 -0800 (PST)
From: rohithvjp2006 <rohithvjp2006@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel compilation
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: rohithvjp2006@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


              
hi this is rohith
                    i am doing project such as porting an linux 2.4 fedora
to some target say x86 when i modified the kernel by make menuconfig command
and after doin make dep there is no error but when i given make bzImage  i
am getting this error please reply me what it means and i am very new to
this linux field can any body help
                    and if the target as arm 9 what i should do where i
should change


regards rohith


   from base.c:635:
/usr/src/linux-2.4.22-1.2115.nptl/include/asm/processor.h:257:1: warning:
this is the location of the previous definition
base.c: In function `is_devfsd_or_child':
base.c:1417: structure has no member named `p_opptr'
base.c:1417: structure has no member named `p_opptr'
make[3]: *** [base.o] Error 1
make[3]: Leaving directory `/usr/src/linux-2.4.22-1.2115.nptl/fs/devfs'
make[2]: *** [first_rule] Error 2
make[2]: Leaving directory `/usr/src/linux-2.4.22-1.2115.nptl/fs/devfs'
make[1]: *** [_subdir_devfs] Error 2
make[1]: Leaving directory `/usr/src/linux-2.4.22-1.2115.nptl/fs'
make: *** [_dir_fs] Error 2
[root@rohit linux-2.4]#


-- 
View this message in context: http://www.nabble.com/kernel-compilation-tp14614652p14614652.html
Sent from the linux-kernel mailing list archive at Nabble.com.

