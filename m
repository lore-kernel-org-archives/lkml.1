Return-Path: <linux-kernel-owner+w=401wt.eu-S1751385AbXFVWjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbXFVWjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbXFVWi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:38:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58164 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbXFVWiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:38:55 -0400
Date: Sat, 23 Jun 2007 00:38:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 4/6] Make DRM use the tasklet is-sched API
Message-ID: <20070622223805.GA31938@elte.hu>
References: <20070622040014.234651401@goodmis.org> <20070622040137.104281523@goodmis.org> <1182494169.3228.11.camel@dhcp193.mvista.com> <1182494960.20203.34.camel@chaos> <1182496085.3228.26.camel@dhcp193.mvista.com> <1182514525.5493.4.camel@localhost.localdomain> <1182526602.3228.43.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182526602.3228.43.camel@dhcp193.mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > The two patches have two different objectives, even though they are 
> > related and currently on a 1 to 1 basis. The patches regardless, 
> > should stay separate.
> 
> I'm not convinced yet .. One more stab?

uhm, i dont think Steve needs to 'convince' you. You have been (once 
again ...) given extensive explanations about a really trivial topic, 
but you keep pushing and demanding very agressively without apparently 
reading the answers. If you dont want to or cannot understand it's 
really your problem to solve, not Steve's ...

	Ingo
