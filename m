Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYC1QLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYC1QLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYC1QLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:11:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53001 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYC1QL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:11:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Date: Fri, 28 Mar 2008 17:11:26 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Ben Nizette <bn@niasdigital.com>
References: <200803272353.51901.rjw@sisk.pl> <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org> <20080328122925.3131484c@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <20080328122925.3131484c@hskinnemo-gx620.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281711.27131.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 28 of March 2008, Haavard Skinnemoen wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9976
> > > Subject		: BUG: 2.6.25-rc1: iptables postrouting setup causes oops
> > > Submitter	: Ben Nizette <bn@niasdigital.com>
> > > Date		: 2008-02-12 12:46 (45 days old)
> > > References	: http://lkml.org/lkml/2008/2/12/148
> > > Handled-By	: Haavard Skinnemoen <hskinnemoen@atmel.com>  
> > 
> > This one seems gone (and was apparently AVR-only):
> > 
> > http://lkml.org/lkml/2008/2/13/607:
> >   "What ever the problem is it isn't immediately apparent in latest git so
> >    I guess we'll just have to keep our eyes peeled."
> 
> Yes, I haven't been able to reproduce it, so I was going to ask for it
> to be removed. I suspect it must be some sort of -rc1 weirdness that
> has been fixed by a later commit.
> 
> I don't feel good about closing it without knowing what it was, but
> since neither Ben nor I can reproduce it anymore, I don't have any
> better suggestions.

I closed it as "unreproducible".

Thanks,
Rafael
