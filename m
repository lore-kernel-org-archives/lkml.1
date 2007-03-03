Return-Path: <linux-kernel-owner+w=401wt.eu-S1030333AbXCCP3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030333AbXCCP3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 10:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030381AbXCCP3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 10:29:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:39326 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030333AbXCCP3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 10:29:50 -0500
Cc: venkatesh.pallipadi@intel.com, eranian@hpl.hp.com,
       linux-kernel@vger.kernel.org, bunk@stusta.de, jirislaby@gmail.com,
       domi.dumont@free.fr, linux-dvb@linuxtv.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset="us-ascii"
Date: Sat, 03 Mar 2007 16:29:48 +0100
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <20070301091452.7f1bd700.randy.dunlap@oracle.com>
Message-ID: <20070303152948.65370@gmx.net>
MIME-Version: 1.0
References: <20070301143407.29950@gmx.net>
 <20070301091452.7f1bd700.randy.dunlap@oracle.com>
Subject: Re: 2.6.21-rc1-git2 is incompilable
To: Randy Dunlap <randy.dunlap@oracle.com>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/lKlFzO2jlFpHhx0MjBtwJcKhQ71a9WkXmGE1PdX
 z50LMYShy4CgFIBb3NN0AbOnKxsewwaoo9iA== 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Thu, 1 Mar 2007 09:14:52 -0800
Von: Randy Dunlap <randy.dunlap@oracle.com>
An: "Uwe Bugla" <uwe.bugla@gmx.de>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org, linux-dvb@linuxtv.org, domi.dumont@free.fr, Jiri Slaby <jirislaby@gmail.com>, bunk@stusta.de, linux-kernel@vger.kernel.org, Stephane Eranian <eranian@hpl.hp.com>, venkatesh.pallipadi@intel.com
Betreff: Re: 2.6.21-rc1-git2 is incompilable

> On Thu, 01 Mar 2007 15:34:07 +0100 Uwe Bugla wrote:
> 
> > Hi folks,
> > trying to compile kernel 2.6.21-rc1-git2 is impossible. The broken
> module where the compiler gives up is /arch/i386/kernel/io_apic.c.
> > 
> > Regards
> > 
> > Uwe
> > 
> > P. S.: Wouldn't it be a good idea to test at least error-free
> compilation before stuff like this is being published?
> 
> 1) 2.6.*-gitN kernels are automated snapshots of Linus's git kernel tree.
> There is no coordination between Linus adding changesets to his kernel
> tree and some script reading changes out of it.  (I could read your
> note as saying that there should be some coordination, I suppose.)
> 
> 2) Linus doesn't build i386 non-SMP kernels AFAIK.
> 
> 3) The small bug has been discussed & fixed (several times).
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code
> ***
Thank you, Randy

-- 
"Feel free" - 5 GB Mailbox, 50 FreeSMS/Monat ...
Jetzt GMX ProMail testen: www.gmx.net/de/go/mailfooter/promail-out
