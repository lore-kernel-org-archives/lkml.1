Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXIMIOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXIMIOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbXIMIOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:14:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:49888 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752874AbXIMIOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:14:01 -0400
Cc: davidel@xmailserver.org, vda.linux@googlemail.com, rdunlap@xenotime.net,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, drepper@redhat.com, stable@kernel.org,
       hch@lst.de, jengelh@computergmbh.de, corbet@lwn.net
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 13 Sep 2007 10:13:59 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <20070912193920.441cf901.akpm@linux-foundation.org>
Message-ID: <20070913081359.216550@gmx.net>
MIME-Version: 1.0
References: <20070825064114.107820@gmx.net>
	<20070904011800.762523a4.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
	<200709051312.21873.vda.linux@googlemail.com>	<20070905153201.236690@gmx.net>
 <20070912193920.441cf901.akpm@linux-foundation.org>
Subject: Re: timerfd redux
To: Andrew Morton <akpm@linux-foundation.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+R5s1pEuORKiiV5fxKazqwyJIRrKy/nr11gRPVln
 uhpGB+Ks6wXP4dd1aZYR3UGUfKVDcL51979g== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: f8ned6VnYmYBZpCoHnY3NA5CWkZTQdRX
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

> > 3. possible solutions
> 
> I don't think we'll have this settled and coded in time for 2.6.23.  So I
> think the prudent thing to do is to push this back to 2.6.24 and not offer
> sys_timerfd() in 2.6.23.

Did you want a patch to remove the syscall number for now,
or will you do that?

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

