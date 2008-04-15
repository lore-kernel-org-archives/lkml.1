Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbYDOWtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbYDOWtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 18:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYDOWt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 18:49:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48224 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbYDOWt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 18:49:27 -0400
Date: Wed, 16 Apr 2008 00:48:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: lkml@rtr.ca, jesper.juhl@gmail.com, tilman@imap.cc,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, corbet@lwn.net,
       torvalds@linux-foundation.org
Subject: Re: about bisections
Message-ID: <20080415224849.GA14592@elte.hu>
References: <47FEB062.3020003@rtr.ca> <20080410.173911.179180620.davem@davemloft.net> <20080415215306.GA7437@elte.hu> <20080415.153003.36624305.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415.153003.36624305.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 15 Apr 2008 23:53:06 +0200
> 
> > but please do _not_ require it from testers and users.
> 
> I don't.  I ask for a bisection when it is appropriate and I think 
> other avenues will not bear fruit in a reasonable amount of time.

i'm glad i misunderstood you. My impression from reading this thread was 
that you preferred reporters who do bisection (which is fine so far), to 
the level of sometimes ignoring reporters who dont (which is not).

> Thanks for the arbitrary diatribe about my contributions over the 
> years and accusations that I have some kind of monopoly over the 
> networking code and fixes to it.  I really appreciate that.

you certainly do have a fair amount of exclusivity in determining the 
dosage of networking commits. Dont get me wrong, you earned it and you 
deserve it - not the least because you do it best.

	Ingo
