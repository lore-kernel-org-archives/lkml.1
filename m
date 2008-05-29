Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbYE2UYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbYE2UYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYE2UYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:24:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40741 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYE2UYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:24:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Date: Thu, 29 May 2008 22:24:34 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jiri Kosina <jkosina@suse.cz>,
       ksummit-2008-discuss@lists.linux-foundation.org, penberg@cs.helsinki.fi,
       dwmw2@infradead.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
References: <1212010931.3445.103.camel@localhost.localdomain> <Pine.LNX.4.64.0805291656000.6718@jikos.suse.cz> <1212082624.3428.45.camel@localhost.localdomain>
In-Reply-To: <1212082624.3428.45.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805292224.35440.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 29 of May 2008, James Bottomley wrote:
> On Thu, 2008-05-29 at 17:06 +0200, Jiri Kosina wrote:
> > On Thu, 29 May 2008, James Bottomley wrote:
> > 
> > > Really, I think that's what our mistake is in the recruitment program 
> > > is: we need to start people out on useful tasks that they can do rather 
> > > than on tasks we find annoying and useless in the hope they move on to 
> > > something better.
> > 
> > I fully agree, but my impression is that this really is not going to be 
> > easy. Fixing bugs definitely is a good way to start kernel coding -- it 
> > forces you to understand the internals of the source, get used to the 
> > coding style by reading the code, etc. Unfortunately, it's simply not very 
> > attractive for newcomers.
> 
> Yes, that's why I think they don't start with bug fixing, they start
> with testing (which, of course naturally leads to bug reporting and
> possibly even fixing).
> 
> > For example -- I am leading a seminar at university, oriented at linux 
> > kernel internals. I provide the possibility to students either to
> > 
> > - write some stand-alone interesting kernel project
> > - fix a few non-trivial bugs in kernel bugzilla
> > - chose any part of a kernel, learn how it works, and present this to 
> >   other seminar attendees
> > 
> > The feedback I often get from students (and these guys are studying 
> > computer science) is
> > 
> > - writing some wholy new interesting kernel project is usually too 
> >   complicated (both coming with an interesting idea for a project, and 
> >   doing the coding itself)
> > - fixing random bugs from kernel bugzilla is boring (spending 10 hours 
> >   looking for missing '=' doesn't really attract them)
> > 
> > So in overwhelming majority of cases, they just chose the presentation.
> > 
> > 
> > All I want to say is that I could very well imagine that a lot of 
> > newcomers will find "hey, feel free to crawl through bugzilla and fix 
> > whatever you are able to fix" very non-attractive.
> 
> Right ... for me to fix a bug, it really has to be relevant, which
> finding some random one in the bugzilla isn't, so the most motivated
> person on a bug should be the reporter.

Agreed.

> That's why I think we start newbies off with testing the kernel of the day
> and seeing what goes wrong.  If something does, they have the bug right there
> in front of them.  Just reporting it and helping others fix it is a useful service.
> If they actually move on to investigating and fixing it themselves, so
> much the better.

Agreed again.

Generally, I think a good way to start is to ask yourself if there are any
problems with the kernel that you see on your own box and you'd like to fix,
then try to understand why these problems occur and try to provide a solution.

> > Not that I have any better idea right now, though.
> 
> Well, apart from bug fixing and testing, I don't either ... that's why
> I'm proposing a discussion not a solution.

Well, people usually have some problems with the kernel, not necessarily bugs,
but things that are somehow annoying or apparently possible to improve (eg. to
speed up).  Sometimes the kernel doesn't work as expected, etc.  IMO, it would
be nice if people started from looking at things that don't work for them
ideally.

Thanks,
Rafael
