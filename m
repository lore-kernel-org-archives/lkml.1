Return-Path: <linux-kernel-owner+w=401wt.eu-S1760450AbXGXQwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450AbXGXQwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 12:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbXGXQwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 12:52:42 -0400
Received: from xenotime.net ([66.160.160.81]:44213 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754270AbXGXQwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 12:52:41 -0400
Date: Tue, 24 Jul 2007 09:57:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: corbet@lwn.net (Jonathan Corbet),
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/7] lguest: documentation pt I: Preparation
Message-Id: <20070724095733.99a8af2d.rdunlap@xenotime.net>
In-Reply-To: <20070724170028.42c6bd8d@the-village.bc.nu>
References: <20070723171238.1a832b31.akpm@linux-foundation.org>
	<5659.1185289994@lwn.net>
	<20070724170028.42c6bd8d@the-village.bc.nu>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 17:00:28 +0100 Alan Cox wrote:

> > P.S. I am currently considering a no-limericks policy for the LWN quote
> > of the week.
> 
> The LWN quote of the week
> Is I think rather weak
> No poems allowed
> To rise from the crowd
> Its future looks terribly bleak
> 
> More seriously the documentation looks good, and it definitely wants a
> date/release clearly mentioning so people know when it is obsolete
> 
> > Advantage:  it does keep the source code + doc text together.
> > Martin (former kernel-doc maintainer) was going to come up with
> > some way to do this, but he abandoned it. 
> 
> It's not clear to me how you then format the extracted material. It

Yes, that's certainly a challenge with the current kernel-doc script.

> doesn't really fit the kernel-doc idea of formats. It would probably be
> far easier to teach a seperate tool to rip clearly marked blocks into
> ASCII documentation files for that purpose

which is what Rusty's extract script does.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
