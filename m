Return-Path: <linux-kernel-owner+w=401wt.eu-S932960AbXGWS7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbXGWS7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757604AbXGWS64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:58:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37464 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983AbXGWS6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:58:55 -0400
Date: Mon, 23 Jul 2007 20:58:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] release quicklist before free_page
Message-ID: <20070723185832.GA31151@elte.hu>
References: <20070723152129.036573829@mvista.com> <1185208378.8197.20.camel@twins> <1185207979.2573.55.camel@imap.mvista.com> <20070723182301.GA27789@elte.hu> <1185215232.2573.72.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185215232.2573.72.camel@imap.mvista.com>
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


* Daniel Walker <dwalker@mvista.com> wrote:

> (btw, your comment above comes off very snide, which I don't 
> appreciate. I haven't done anything that remotely warrants that.)

That snideness is simply a reflection, to make you realize how it feels. 
I tried to point this issue out to you in the past, but here we go 
again, back to square one. But i'm not giving up on you :-)
 
Peter sent a patch to a subtly buggy patch of yours (which introduces a 
bug worse than it fixes), with this comment:

 | | How about this - compile tested only

and you replied in this almost flagrant tone:

 | How about a comment to go with it ?  Which says something like what's 
 | above, notes on how the locking is getting used.. "

that kind of tone can be offensive, in such a context. I _know_ you 
(still) dont realize it as offensive and that you dont accept my 
characterisation of it, but nevertheless it's a fact and i'm going to 
complain about it to you when i see you do it.

A proper polite answer to the helpful patch of Peter would have been 
what i suggested:

> > how about: "if you've got some time then please also add a few 
> > comments, because the code was quite non-obvious to me and I 
> > misunderstood it when I tried to fix it. Thanks."

the basis of writing such replies is a certain level of humility and 
fundamental respect towards the capabilities of other kernel developers. 
Do you have it? If yes, are you willing to express it? If yes then 
please do so.

	Ingo
