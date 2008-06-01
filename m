Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbYFAOLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbYFAOLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYFAOL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:11:26 -0400
Received: from www.tglx.de ([62.245.132.106]:55435 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbYFAOLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:11:25 -0400
Date: Sun, 1 Jun 2008 16:11:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: tytso@mit.edu, benh@kernel.crashing.org,
       James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
In-Reply-To: <20080529.143921.34376298.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0806011605590.3235@apollo.tec.linutronix.de>
References: <20080529124548.GC8065@mit.edu> <20080529.135431.235149338.davem@davemloft.net> <20080529211404.GH8065@mit.edu> <20080529.143921.34376298.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, David Miller wrote:
> From: Theodore Tso <tytso@mit.edu>
> Date: Thu, 29 May 2008 17:14:04 -0400
> 
> > On Thu, May 29, 2008 at 01:54:31PM -0700, David Miller wrote:
> > > Yes, process is important, but I'd say it deserved 1/3 of the summit
> > > time, but not one minute more.
> > 
> > We were about 50-50 last time, roughly.  So let's see if there is
> > consensus to dial it back this year, based on topics that people
> > suggest.
> 
> Today at LinuxTAG, Thomas Gleixner and I tossed around the idea
> that (assuming a 3 day event) we do tech stuff on day 1, process
> stuff on day 2, and back to tech stuff on day 3.
> 
> The idea is that you hash out the initial impressions of your
> ideas on day 1, your mind works on the problem in the background
> on day 2, and they everyone has the answers on day 3 :-)
> 
> Another idea we discussed briefly was some kind of organized run
> over the bugzilla entries.  And just to make it interesting we could
> award some silly prize to whoever fixed the most interesting or
> amusing bug during the bug-run, as voted by the attendees.

I thought more about it and came up with an interesting challange for
the top hackers crowd:

Fix NOHZ/CPUIDLE along with suspend/resume on all participants
laptops, which are probably 50+ different models. That'd be an odd
enough mix of wreckaged hardware / BIOS / ACPI.

Should be fun and solve a bunch of hard to grok bugs in the bugzillas
along the way.

Thanks,
	tglx
