Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbYE2RhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbYE2RhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbYE2RhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:37:10 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35121 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753388AbYE2RhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:37:09 -0400
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: ksummit-2008-discuss@lists.linux-foundation.org, penberg@cs.helsinki.fi,
       dwmw2@infradead.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805291656000.6718@jikos.suse.cz>
References: <1212010931.3445.103.camel@localhost.localdomain>
	 <1212013125.2236.58.camel@shinybook.infradead.org>
	 <1212014127.3445.115.camel@localhost.localdomain>
	 <20080528.230934.131215087.davem@davemloft.net>
	 <1212071813.3428.22.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0805291656000.6718@jikos.suse.cz>
Content-Type: text/plain
Date: Thu, 29 May 2008 12:37:04 -0500
Message-Id: <1212082624.3428.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 17:06 +0200, Jiri Kosina wrote:
> On Thu, 29 May 2008, James Bottomley wrote:
> 
> > Really, I think that's what our mistake is in the recruitment program 
> > is: we need to start people out on useful tasks that they can do rather 
> > than on tasks we find annoying and useless in the hope they move on to 
> > something better.
> 
> I fully agree, but my impression is that this really is not going to be 
> easy. Fixing bugs definitely is a good way to start kernel coding -- it 
> forces you to understand the internals of the source, get used to the 
> coding style by reading the code, etc. Unfortunately, it's simply not very 
> attractive for newcomers.

Yes, that's why I think they don't start with bug fixing, they start
with testing (which, of course naturally leads to bug reporting and
possibly even fixing).

> For example -- I am leading a seminar at university, oriented at linux 
> kernel internals. I provide the possibility to students either to
> 
> - write some stand-alone interesting kernel project
> - fix a few non-trivial bugs in kernel bugzilla
> - chose any part of a kernel, learn how it works, and present this to 
>   other seminar attendees
> 
> The feedback I often get from students (and these guys are studying 
> computer science) is
> 
> - writing some wholy new interesting kernel project is usually too 
>   complicated (both coming with an interesting idea for a project, and 
>   doing the coding itself)
> - fixing random bugs from kernel bugzilla is boring (spending 10 hours 
>   looking for missing '=' doesn't really attract them)
> 
> So in overwhelming majority of cases, they just chose the presentation.
> 
> 
> All I want to say is that I could very well imagine that a lot of 
> newcomers will find "hey, feel free to crawl through bugzilla and fix 
> whatever you are able to fix" very non-attractive.

Right ... for me to fix a bug, it really has to be relevant, which
finding some random one in the bugzilla isn't, so the most motivated
person on a bug should be the reporter.  That's why I think we start
newbies off with testing the kernel of the day and seeing what goes
wrong.  If something does, they have the bug right there in front of
them.  Just reporting it and helping others fix it is a useful service.
If they actually move on to investigating and fixing it themselves, so
much the better.

> Not that I have any better idea right now, though.

Well, apart from bug fixing and testing, I don't either ... that's why
I'm proposing a discussion not a solution.

James


