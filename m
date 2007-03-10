Return-Path: <linux-kernel-owner+w=401wt.eu-S1750957AbXCJSJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750957AbXCJSJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 13:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbXCJSJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 13:09:38 -0500
Received: from smtpauth02.prod.mesa1.secureserver.net ([64.202.165.182]:43305
	"HELO smtpauth02.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750943AbXCJSJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 13:09:37 -0500
Message-ID: <45F2F45F.6000403@seclark.us>
Date: Sat, 10 Mar 2007 13:09:35 -0500
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: ck list <ck@vds.kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: RSDL v0.28 for 2.6.20
References: <200703101845.59497.kernel@kolivas.org>
In-Reply-To: <200703101845.59497.kernel@kolivas.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:

>Here is an update for RSDL to version 0.28
>
>Full patch:
>http://ck.kolivas.org/patches/staircase-deadline/2.6.20-sched-rsdl-0.28.patch
>
>Series:
>http://ck.kolivas.org/patches/staircase-deadline/2.6.20/
>
>The patch to get you from 0.26 to 0.28:
>http://ck.kolivas.org/patches/staircase-deadline/2.6.20/sched-rsdl-0.26-0.28.patch
>
>A similar patch and directories will be made for 2.6.21-rc3 without further 
>announcement
>
>  
>
doesn't apply against 2.6.20.2:

patch -p1 <~/2.6.20-sched-rsdl-0.28.patch --dry-run
patching file include/linux/list.h
patching file fs/proc/array.c
patching file fs/pipe.c
patching file include/linux/sched.h
patching file include/asm-generic/bitops/sched.h
patching file include/asm-s390/bitops.h
patching file kernel/sched.c
Hunk #41 FAILED at 3531.
1 out of 62 hunks FAILED -- saving rejects to file kernel/sched.c.rej
patching file include/linux/init_task.h
patching file Documentation/sched-design.txt

Steve
-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



