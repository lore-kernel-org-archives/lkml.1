Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYE1Vma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYE1Vma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbYE1VmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:42:17 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54647 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753261AbYE1VmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:42:16 -0400
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Woodhouse <dwmw2@infradead.org>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <84144f020805281431y1aac903am442b333a2a13cd15@mail.gmail.com>
References: <1211995212.3445.52.camel@localhost.localdomain>
	 <1212007760.2236.17.camel@shinybook.infradead.org>
	 <1212008517.3445.89.camel@localhost.localdomain>
	 <84144f020805281431y1aac903am442b333a2a13cd15@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 28 May 2008 16:42:11 -0500
Message-Id: <1212010931.3445.103.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 00:31 +0300, Pekka Enberg wrote:
> On Thu, May 29, 2008 at 12:01 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > Right, but that's why I think we have to change the process.  If we keep
> > the Janitors project, then the bar has to be raised so that it becomes
> > more participatory and thought oriented (i.e. eliminate from the outset
> > anyone who is not going to graduate from mechanical changes to more
> > useful ones).
> 
> I'm not sure what you expect to happen if we "shut down" the Janitors
> project. The important janitorial work doesn't just magically
> disappear. For example, we still need people for:

I'm just outlining the possible solutions; shutting it down wasn't the
one I advocated. One can argue that janitorial changes with enough
intrinsic value tend to get done anyway regardless of whether we have
the project or not.

>   - Fixing API misuse
>   - Converting code from old APIs to new ones
>   - Consolidating duplicate code
>   - Fixing error handling code
>   - Removing unused code
>   - De-obfuscating code (e.g. removing bad macro magic, etc.)
> 
> And, quite frankly, I don't see what the big fuss is about. I know
> we've had way too many "whitespace cleanup" patches in the past six
> months or so, but can't we just NAK them politely and be done with it?

The problem is that there's something in the way all of this is working
that's causing politeness to get short shrift. In turn that's giving
lkml a larger than normal reputation for being a free for all dog fight
and discouraging potential contributors from coming forwards.

Appeals to be politer tend to only work in the short term (having given
quite a few of them).  I think we're developing a root cause problem in
the way we recruit people to work in the kernel and we have to think
about fixing it there.

James


