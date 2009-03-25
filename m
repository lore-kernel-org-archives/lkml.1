Return-Path: <linux-kernel-owner+w=401wt.eu-S1762854AbZCYP1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762854AbZCYP1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762592AbZCYP11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:27:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34245 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762826AbZCYP10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:27:26 -0400
Date: Wed, 25 Mar 2009 16:27:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: Credit for vsprintk work
Message-ID: <20090325152706.GA3546@elte.hu>
References: <alpine.DEB.2.00.0903250949420.5675@gandalf.stny.rr.com> <alpine.DEB.2.00.0903251016540.5675@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903251016540.5675@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> 
> 
> On Wed, 25 Mar 2009, Steven Rostedt wrote:
> 
> > 
> > Frederic,
> > 
> >  $ git blame lib/vsprintf.c |grep 'Frederic Weisbecker' | wc -l
> > 542
> > 
> > You did a hell of a lot of work on vsprintf.c, and you are still too 
> > modest to put in a copyright at the top.
> > 
> > I know some people think that git is good enough for ownership. But 
> > really, the amount of changes that you did in vsprintf.c deserves a bit of 
> > credit in the source file.
> > 
> > Is everyone OK if a copyright goes at the top of this file giving credit 
> > to Frederic?  If for anything else, it will facilitate people to find who 
> > broke it if it breaks ;-)
> > 
> > I think Frederic should send one more patch to add his copyright. That is, 
> > of course, if Frederic wants too.
> > 
> > Note, Frederic did not ask me to post this. In fact, this is the first 
> > time he's seen this complaint. I'm posting this because I was showing this 
> > code to some students at a University and when I wanted to point out 
> > who wrote it, I was surprised that Frederic's name was not mentioned.
> > I was looking at the code via LXR so git was not helpful here.
> 
> Lai also did this work too, so I recommend adding something like:
> 
>  * Binary printk modifications, copyright 2009:
>  *  Frederic Weisbecker <fweisbec@gmail.com>
>  *  Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Or something similar.

I'd suggest the standard copyright form:

  *
  * Binary printk modifications and generalizations:
  *
  *    Copyright (C) 2009  Frederic Weisbecker <fweisbec@gmail.com>
  *    Copyright (C) 2009  Lai Jiangshan <laijs@cn.fujitsu.com>
  * 

	Ingo
