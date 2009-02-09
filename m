Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbZBIAb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbZBIAb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 19:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZBIAbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 19:31:17 -0500
Received: from [222.92.8.141] ([222.92.8.141]:42879 "EHLO lemote.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbZBIAbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 19:31:16 -0500
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Feb 2009 19:31:16 EST
Message-ID: <20955.222.92.8.142.1234138032.squirrel@mail.lemote.com>
Date: Mon, 9 Feb 2009 08:07:12 +0800 (CST)
Subject: the current status of RT_PREEMPT for mips
From: wuzj@lemote.com
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain;charset=gb2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI!

I'm planning to port RE_PREEMPT to loongson2f(a mipsel compatible
processor), the "FAQ" web page of RTWiKi(rt.wiki.kernel.org) shows that
"There are systems representing the x86, x86_64, ARM, MIPS, and Power
architectures using the CONFIG_PREEMPT_RT patch.", does it means that
RT_PREEMPT support  MIPS architecture? because i can not find any more
information about it, I tried to use the latest RT_PREEMPT on qemu
0.9.1/mipssim, it can not boot, so I come to get your help, could you give
any current status of RT_PREEMPT for mips? such as:

1. does the latest RT_PREEMPT(for linux 2.6.26.8) support MIPS
architecture? or any older one support it?
2. if Yes, which MIPS processors have been successfully running RT_PREEMPT?

looking forward to your reply, thanks!

Best Regards,
falcon

