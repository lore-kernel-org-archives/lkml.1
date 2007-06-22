Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbXFVXcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbXFVXcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXFVXcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:32:08 -0400
Received: from homer.mvista.com ([63.81.120.158]:56423 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbXFVXcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:32:07 -0400
Subject: Re: [RFC PATCH 4/6] Make DRM use the tasklet is-sched API
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
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
In-Reply-To: <20070622223805.GA31938@elte.hu>
References: <20070622040014.234651401@goodmis.org>
	 <20070622040137.104281523@goodmis.org>
	 <1182494169.3228.11.camel@dhcp193.mvista.com>
	 <1182494960.20203.34.camel@chaos>
	 <1182496085.3228.26.camel@dhcp193.mvista.com>
	 <1182514525.5493.4.camel@localhost.localdomain>
	 <1182526602.3228.43.camel@dhcp193.mvista.com>
	 <20070622223805.GA31938@elte.hu>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 16:28:05 -0700
Message-Id: <1182554886.3228.141.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-23 at 00:38 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > > The two patches have two different objectives, even though they are 
> > > related and currently on a 1 to 1 basis. The patches regardless, 
> > > should stay separate.
> > 
> > I'm not convinced yet .. One more stab?
> 
> uhm, i dont think Steve needs to 'convince' you. You have been (once 
> again ...) given extensive explanations about a really trivial topic, 
> but you keep pushing and demanding very agressively without apparently 
> reading the answers. If you dont want to or cannot understand it's 
> really your problem to solve, not Steve's ...

Your right Steven doesn't need to convince me. He requested comments and
I gave them, if he or you want to ignore them that's your prerogative.

How can you say I didn't read the answers .. I said "I read this 5
times" ! It doesn't get much more explicit than that .. In fact, my
response was mainly cause I thought his explanation was confusing.. How
can you fault _me_ for that, it's the medium we're using.

It seems like you assume all my emails are "demanding" and "aggressive",
where I'm just asking questions and making comments .. Who am I to be
making demands of anyone ?

<joke>
I DEMAND you do what I say! You better do it or else! I'll force Linus
to ignore you, so you better do it.
</joke>

Daniel

