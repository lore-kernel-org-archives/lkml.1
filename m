Return-Path: <linux-kernel-owner+w=401wt.eu-S935459AbXHJOTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935459AbXHJOTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938605AbXHJOS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:18:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37090 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938387AbXHJOSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:18:54 -0400
Date: Fri, 10 Aug 2007 16:18:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070810141841.GA5473@elte.hu>
References: <Pine.LNX.4.64.0708011511530.1817@scrub.home> <20070801150742.GA23670@elte.hu> <p73ps27npu0.fsf@bingen.suse.de> <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org> <20070801175004.GA17936@elte.hu> <Pine.LNX.4.64.0708011955430.1817@scrub.home> <20070801190556.GA1199@elte.hu> <Pine.LNX.4.64.0708100037460.1817@scrub.home> <20070810054948.GA5908@elte.hu> <Pine.LNX.4.64.0708101459530.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708101459530.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> > Also, could you please send me 
> > the cfs-debug-info.sh:
> > 
> >   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> > 
> > captured _while_ the above workload is running. This is the third time 
> > i've asked for that :-)
> 
> Is there any reason to believe my analysis is wrong?

please first give me the debug data captured with the script above 
(while the workload is running) - so that i can see the full picture 
about what's happening. Thanks,

	Ingo
