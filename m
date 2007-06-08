Return-Path: <linux-kernel-owner+w=401wt.eu-S969493AbXFHQDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969493AbXFHQDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763697AbXFHQDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:03:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:59658 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760660AbXFHQDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:03:22 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1+gat1+R/agUgifu86uLVMVkhHrirLNFlFOwp2vE1
	a1vPsBY7h3YPsF
Message-ID: <46697DD1.5060307@gmx.net>
Date: Fri, 08 Jun 2007 18:03:29 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Gerhard Mack <gmack@innerfire.net>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: man-pages-2.54 is released
References: <46695095.2020503@gmx.net> <Pine.LNX.4.64.0706081001210.27398@mtl.rackplans.net>
In-Reply-To: <Pine.LNX.4.64.0706081001210.27398@mtl.rackplans.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerhard Mack wrote:
> On Fri, 8 Jun 2007, Michael Kerrisk wrote:
> 
>> I just released man-pages-2.54
>>
> 
> This may sound like a dumb question but since you just released 
> man-pages-2.52 and man-pages-2.53 recently as one batch and now this one. 

Let's just say that I've been very busy lately...  (Getting some paid time
to work on man-pages helps a lot!)  One reason that releases get split up
is that for major edits (especially for formatting as opposed to content),
I am trying to separate the edits into separate releases to ease the life
of some downstream maintainers and translators.  From the MAINTAINING file
in the tarball:

    One day, it won't be me any more, so to make life easier for the
    next maintainer: some tips on how to maintain the Linux manual
    pages

    ...

    Release Philosophy
    ==================

    If you make sweeping *formatting* changes on a large number of
    pages, separate them out into their own release that contains
    minimal *content* changes.  This makes it easier for the people
    that want to verify content changes independently of the change
    log.  Yes, some people actually diff each release to see what
    changed; for example, downstream maintainers, and translators of
    the man pages (such as the dedicated Alain Portal, in recent
    times) sometimes like to do this.

> What is the difference between the versions and how do I know wich to 
> install?

The latest is, well, the latest.  (Take a look at Changes and Changes.old
in each release.)  Today, you want 2.54.  In a few days, you're likely to
want 2.55 ;-).

Best regards,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
