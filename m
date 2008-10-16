Return-Path: <linux-kernel-owner+w=401wt.eu-S1760556AbYJPRc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556AbYJPRc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbYJPRQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:16:37 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:60068 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805AbYJPRQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:16:36 -0400
Date: Thu, 16 Oct 2008 20:16:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081016171626.GB22554@cs181140183.pp.htv.fi>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016153053.GJ5834@nostromo.devel.redhat.com> <20081016154726.GA6331@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081016154726.GA6331@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 08:47:26AM -0700, Greg KH wrote:
> On Thu, Oct 16, 2008 at 11:30:53AM -0400, Bill Nottingham wrote:
> > Greg KH (greg@kroah.com) said: 
> > > Distros properly patch things and backport "urgent OpenSSL security
> > > updates" to older versions of packages, so they would not run into this
> > > problem.
> > > 
> > > Newer releases would run into this problem, but as almost all distros
> > > have huge, easy to run, build systems, a change like this would show up
> > > immediately and be fixed in a matter of hours, with the needed fixes
> > > being pushed upstream to the various packages as needed.
> > > 
> > > So I really don't think this is much of a problem.
> > > 
> > > It's interesting that openssl doesn't just check for Linux 1.x and
> > > assumes that Linux 9.23.12 will work just fine with what they are doing :)
> > 
> > Is it really worth the effort of having any such upstream have to
> > quickly patch and release, when the only benefit listed (earlier in
> > this thread) was to inform people how old their kernel is?
> 
> If we switch to a consecutive numbering scheme, which doesn't show the
> "age" of the kernel, we would still have to patch such packages, so I
> don't see the big difference.

You miss the best alternative:

Simply keep the status quo.

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

