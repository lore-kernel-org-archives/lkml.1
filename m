Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbYCaUbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbYCaUbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 16:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbYCaUbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 16:31:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41287 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbYCaUbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 16:31:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.25-rc7-git5: Reported regressions from 2.6.24
Date: Mon, 31 Mar 2008 22:31:07 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Mark Lord <lkml@rtr.ca>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803310228.11027.rjw@sisk.pl> <47F13A5A.7040305@rtr.ca> <20080331193516.GC23259@cs181133002.pp.htv.fi>
In-Reply-To: <20080331193516.GC23259@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803312231.08003.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 31 of March 2008, Adrian Bunk wrote:
> On Mon, Mar 31, 2008 at 03:24:10PM -0400, Mark Lord wrote:
> > Adrian Bunk wrote:
> >> On Mon, Mar 31, 2008 at 01:48:15PM -0400, Mark Lord wrote:
> >>> Rafael,
> >>>
> >>> Add this one to the list?
> >>
> >>
> >> That's not a regression from 2.6.24
> > ..
> >
> > 2.6.24 does not flood my syslog with those messages.
> > 2.6.25-rc* does.   Looks like a regression.
> >
> > The original bug was a hidden regression in 2.6.23,
> > which nobody bothered to identify until now.
> 
> Let's try to get this patch into Linus' tree without arguing 
> whether it might be called a post 2.6.24 regression or not.  ;)
> 
> > Just because some code "gets away with" a regression
> > for a kernel or two, doesn't mean that regression shouldn't be fixed.
> 
> No disagreement on this one.
> 
> We already have over 200 known (and many more once reported) regressions 
> in the kernel, and all of them should be fixed...

The patch have already been merged, BTW.

Thanks,
Rafael
