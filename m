Return-Path: <linux-kernel-owner+w=401wt.eu-S1765553AbYDOUve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765553AbYDOUve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbYDOUv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:51:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52052 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbYDOUvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:51:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Newall <davidn@davidnewall.com>
Subject: Re: Reporting bugs and bisection
Date: Tue, 15 Apr 2008 22:51:49 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, James Morris <jmorris@namei.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       david@lang.hm, Stephen Clark <sclark46@earthlink.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Tilman Schmidt <tilman@imap.cc>,
       Valdis.Kletnieks@vt.edu, Mark Lord <lkml@rtr.ca>,
       David Miller <davem@davemloft.net>, jesper.juhl@gmail.com,
       yoshfuji@linux-ipv6.org, jeff@garzik.org,
       linux-kernel <linux-kernel@vger.kernel.org>, git@vger.kernel.org,
       netdev@vger.kernel.org
References: <47FEADCB.7070104@rtr.ca> <517f3f820804150254w491cdf85s28f1d15696db8d96@mail.gmail.com> <4804B5D5.4090404@davidnewall.com>
In-Reply-To: <4804B5D5.4090404@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804152251.51308.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 15 of April 2008, David Newall wrote:
> Michael Kerrisk wrote:
> > On 4/15/08, David Newall <davidn@davidnewall.com> wrote:
> >   
> >> James Morris wrote:
> >>  > I don't know how to solve this, but suspect that encouraging the use of
> >>  > reviewed-by and also including it in things like analysis of who is
> >>  > contributing, selection for kernel summit invitations etc. would be a
> >>  > start.  At least, better than nothing.
> >>
> >> Would it be hard to keep count of the number of errors introduced by
> >>  author and reviewer?
> >>     
> >
> > I've found quite a few errors in kernel-userland APIs, but I'm not
> > sure that this sort of negative statistic would be helpful -- e.g.,
> > more productive developers probably also introduce more errors.
> 
> We can already see which developers are more active.  What we can't see
> is who is careless, which would be useful to know.  It would also be
> useful to know who is careless in approving changes, because they share
> responsibility for those changes.  It would be a good thing if this
> highlighted that some people are behind frequent buggy changes.

Well, even if someone introduces bugs relatively frequently, but then also
works with the reporters and fixes the bugs timely, it's about okay IMO.

The real problem is when patch submitters don't care for their changes any
more once the patches have been merged.

Thanks,
Rafael
