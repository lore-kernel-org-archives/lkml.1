Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbXEJMZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbXEJMZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbXEJMY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:24:59 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:42383 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474AbXEJMY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:24:58 -0400
X-Originating-Ip: 99.246.112.70
Date: Thu, 10 May 2007 08:24:04 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Simon Arlott <simon@fire.lp0.eu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix misspellings collected by members of KJ list.
In-Reply-To: <464242B6.9020508@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.64.0705100823130.3641@localhost.localdomain>
References: <200705092102.l49L29Bt026911@hera.kernel.org>
 <464242B6.9020508@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Simon Arlott wrote:

> On 09/05/07 22:02, Linux Kernel Mailing List wrote:
> > Gitweb:
> > http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=beb7dd86a101263bf63a78c7c6d4da3849b35bd6
> > Commit:     beb7dd86a101263bf63a78c7c6d4da3849b35bd6
> > Parent:     3dde6ad8fc3939d345a3768464ecff43c91d511a
> > Author:     Robert P. J. Day <rpjday@mindspring.com>
> > AuthorDate: Wed May 9 07:14:03 2007 +0200
> > Committer:  Adrian Bunk <bunk@stusta.de>
> > CommitDate: Wed May 9 07:14:03 2007 +0200
> >
> >     Fix misspellings collected by members of KJ list.
> >         Fix the misspellings of "propogate", "writting" and (oh, the shame
> >     :-) "kenrel" in the source tree.
> >         Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >     Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > ---
> > diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> > index 7710a6a..f6ac1d3 100644
> > --- a/drivers/char/tty_io.c
> > +++ b/drivers/char/tty_io.c
> > @@ -1607,11 +1607,11 @@ void stop_tty(struct tty_struct *tty)
> >  EXPORT_SYMBOL(stop_tty);
> >   /**
> > - *	start_tty	-	propogate flow control
> > + *	start_tty	-	propagate flow control
> >   *	@tty: tty to start
> >   *
> >   *	Start a tty that has been stopped if at all possible. Perform
> > - *	any neccessary wakeups and propogate the TIOCPKT status. If this
> > + *	any neccessary wakeups and propagate the TIOCPKT status. If this
> >   *	is the tty was previous stopped and is being started then the
> >   *	driver start method is invoked and the line discipline woken.
> >   *
>
> There's only one c in necessary.

dang.  well, might as well just apply that patch as we've collected a
few more typoes since then, i'll catch that one on the next pass.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
