Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbYE2OhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbYE2OhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 10:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYE2OhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 10:37:00 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46964 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752333AbYE2Og6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 10:36:58 -0400
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Miller <davem@davemloft.net>
Cc: dwmw2@infradead.org, penberg@cs.helsinki.fi,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080528.230934.131215087.davem@davemloft.net>
References: <1212010931.3445.103.camel@localhost.localdomain>
	 <1212013125.2236.58.camel@shinybook.infradead.org>
	 <1212014127.3445.115.camel@localhost.localdomain>
	 <20080528.230934.131215087.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 29 May 2008 09:36:53 -0500
Message-Id: <1212071813.3428.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-28 at 23:09 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Wed, 28 May 2008 17:35:27 -0500
> 
> > However, even if there were no recruitment problem at all, getting more
> > people involved is always better because it means more contributions.
> 
> This is not true at all.
> 
> If people are getting involved, just for the sake of being involved,
> which there is strong evidence of, then it's not a positive thing.

OK, I agree with this.  The problem with our current recruitment process
is that it seems to encourage non-useful contributions, which is what I
want this discussion to try to change.

> We want people who are passionate about doing things with the
> kernel, are self-motivated, and frankly don't need a ton of hand
> holding and do not work on things that require absolutely no
> thinking.

Right, so we need to start the newbies process at the point where
thought is required.   That's why I think bug hunting and reporting
might be a better way to go about it.

> Look at anyone who is extremely nimble with the kernel, and ask them
> what they worked on to get going with development.  Did Andrew Morton
> fixup whitespace errors when he was starting to become familiar with
> the tree?  Did I?  No, none of us did this stuff.  We read over the
> code and learned how it worked, did a port, optimized a lookup
> algorithm somewhere.
> 
> Consistently we see people turding with whitespace, and not breaking
> out of that cycle.  That is a problem.

Agreed.  And it's the problem I'd like to address in this discussion
item if it gets on the agenda.  Along with ways of encouraging more
useful contributions.

I'm not convinced we need to have a graduated programme where we try to
draw absolutely everybody in and up; as you say, people with interest
and passion will always draw themselves in naturally.  However, I do
think we need to provide contribution avenues for people who aren't
necessarily aiming to become full time kernel developers.

Like you, I find little value in whitespace patches (and much
annoyance); especially from people who never graduate from them.
However, if we get a user who's willing to test the kernel of the day on
their strange laptop every few days, report any problems or bugs they
see and work with people to fix them, that's a fantastically useful
service; it's relatively easy for them to do and if it's all they ever
do, it's enough to be very useful.

Really, I think that's what our mistake is in the recruitment program
is: we need to start people out on useful tasks that they can do rather
than on tasks we find annoying and useless in the hope they move on to
something better.

James


