Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbYGJRgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbYGJRgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759451AbYGJRgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:36:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46874 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759330AbYGJRgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:36:15 -0400
Date: Thu, 10 Jul 2008 19:34:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.26-rc9-git4: Reported regressions from 2.6.25
Message-ID: <20080710173459.GA11648@elte.hu>
References: <4yrA-dRoNlD.A.jcB.ny-cIB@albercik> <200807101725.36175.nickpiggin@yahoo.com.au> <20080710110213.GA6688@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0807101020270.11076@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807101020270.11076@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 10 Jul 2008, Alexey Dobriyan wrote:
> 
> > On Thu, Jul 10, 2008 at 05:25:35PM +1000, Nick Piggin wrote:
> > > 
> > > Attached is my fix for this problem. I don't think it is a 
> > > regression as such, but it can't hurt to go into 2.6.26 IMO.
> 
> Nick, you're a hero.

cool! :)

(hm, could anyone please resend Nick's original mail? The original one 
is not in my lkml folder nor on lkml.org - only the quoted one.)

	Ingo
