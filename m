Return-Path: <linux-kernel-owner+w=401wt.eu-S964937AbXBEWeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937AbXBEWeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964783AbXBEWeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:34:20 -0500
Received: from mx1.suse.de ([195.135.220.2]:33225 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964937AbXBEWeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:34:19 -0500
Date: Mon, 5 Feb 2007 14:33:04 -0800
From: Greg KH <greg@kroah.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Chris Wright <chrisw@sous-sol.org>, torvalds@osdl.org, akpm@osdl.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/50] -stable review
Message-ID: <20070205223304.GA19793@kroah.com>
References: <20070106022753.334962000@sous-sol.org> <45C624D2.9030403@linuxtv.org> <20070205214332.GB18230@kroah.com> <45C7ACAB.6060408@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C7ACAB.6060408@linuxtv.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 05:16:11PM -0500, Michael Krufky wrote:
> Greg KH wrote:
> > On Sun, Feb 04, 2007 at 01:24:18PM -0500, Michael Krufky wrote:
> >> Chris Wright wrote:
> >>> This is the start of the stable review cycle for the 2.6.19.2 release.
> >>> There are 50 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let us know.  If anyone is a maintainer of the proper subsystem, and
> >>> wants to add a Signed-off-by: line to the patch, please respond with it.
> >>>
> >>> These patches are sent out with a number of different people on the
> >>> Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
> >>> to add your name to the list.  If you want to be off the reviewer list,
> >>> also email us.
> >>>
> >>> Responses should be made by Mon Jan 8 02:30 UTC.
> >>> Anything received after that time might be too late.
> >> At which point was 2.6.18.y dropped?  I thought we were always going to keep
> >> the last two stable kernels up-to-date.  Have I been wasting my time fwd'ing
> >> 2.6.18.y patches?
> > 
> > It was dropped a while ago, sorry.
> > 
> > I'll go through the archives and see if there's enough to do a .18
> > release (and the patches are serious enough to warrent it.)
> 
> Actually, I have a few more -stable patches for both 2.6.18.y and 2.6.19.y, if
> you don't mind holding off a day or two (wont have time to prepare these until
> tomorrow evening)...  One of them is a security fix, that allows a non-root user
> to hang the kernel given the correct circumstances.

Ok, that's serious enough :)

I'll wait for your patches.

> Maybe you guys can make some sort of announcement before the -stable kernel is
> closed.  I know that now that 2.6.20 is released, implicitly 2.6.18.y is
> closed... but it's been a long while since the last 2.6.18.y release, so I
> wasn't sure if patches were still being accepted.

I thought we did at the time we did the last release, but I'll try to
remember to highlight it a more prominently next time.

thanks,

greg k-h
