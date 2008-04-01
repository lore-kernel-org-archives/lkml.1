Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYDABnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYDABnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 21:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYDABnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 21:43:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:49178 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYDABnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 21:43:16 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [OT] Re: [patch for 2.6.26 0/7] Architecture Independent Markers
Date: Tue, 1 Apr 2008 03:43:07 +0200
User-Agent: KMail/1.8.2
Cc: Ingo Molnar <mingo@elte.hu>, KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>
References: <20080327132057.449831367@polymtl.ca> <20080328101500.GF30863@elte.hu> <47ECF3F9.4040906@redhat.com>
In-Reply-To: <47ECF3F9.4040906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804010343.07657.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008 14:34, Masami Hiramatsu wrote:
> > for heaven's sake, we can have 3 years of _full Linux kernel history_, 
> > with all 87875 commits, with full changelog and dependencies and full 
> > source code included, packed into a rather tight, 180 MB git repository 
> > ...
> > 
> > [ and then i havent even begun about the on-disk footprint of this 
> >   monstrum, after the packages have been installed: an additional 850 MB.
> >   Puh-lease ... ]
> 
> Thank for Moore's law and all storage engineers, nowadays we can buy
> an 1TB(=1000GB!) HDD with less than $300!(I also surprised...)
> And many other compressed filesystem can be used for saving disk space.

This is not a valid technical reason for creating bloatware.

Bloatware's main problem is not a cost of storing it or
downloading it. The main problem that over time it becomes
an unmaintainable monstrosity nobody is willing to deal with.

I would rather try to find and fix a bug in 2000 lines of C code
than in 200 000 lines.
--
vda
