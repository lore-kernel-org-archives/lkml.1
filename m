Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbYDAOno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbYDAOno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 10:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbYDAOn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 10:43:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772AbYDAOn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 10:43:28 -0400
Message-ID: <47F24720.4020101@redhat.com>
Date: Tue, 01 Apr 2008 10:30:56 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [OT] Re: [patch for 2.6.26 0/7] Architecture Independent Markers
References: <20080327132057.449831367@polymtl.ca> <20080328101500.GF30863@elte.hu> <47ECF3F9.4040906@redhat.com> <200804010343.07657.vda.linux@googlemail.com>
In-Reply-To: <200804010343.07657.vda.linux@googlemail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denys,

Denys Vlasenko wrote:
> On Friday 28 March 2008 14:34, Masami Hiramatsu wrote:
>>> for heaven's sake, we can have 3 years of _full Linux kernel history_, 
>>> with all 87875 commits, with full changelog and dependencies and full 
>>> source code included, packed into a rather tight, 180 MB git repository 
>>> ...
>>>
>>> [ and then i havent even begun about the on-disk footprint of this 
>>>   monstrum, after the packages have been installed: an additional 850 MB.
>>>   Puh-lease ... ]
>> Thank for Moore's law and all storage engineers, nowadays we can buy
>> an 1TB(=1000GB!) HDD with less than $300!(I also surprised...)
>> And many other compressed filesystem can be used for saving disk space.
> 
> This is not a valid technical reason for creating bloatware.
> 
> Bloatware's main problem is not a cost of storing it or
> downloading it. The main problem that over time it becomes
> an unmaintainable monstrosity nobody is willing to deal with.
>
> I would rather try to find and fix a bug in 2000 lines of C code
> than in 200 000 lines.

If it is a program code, you're right.
However, the debuginfo is just a set of data files generated from
c-source code by the compiler, so you don't need to maintain it.

Thank you,

> --
> vda

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

