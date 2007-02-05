Return-Path: <linux-kernel-owner+w=401wt.eu-S964933AbXBEWUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964933AbXBEWUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964923AbXBEWUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:20:15 -0500
Received: from ns.suse.de ([195.135.220.2]:60864 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964857AbXBEWUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:20:13 -0500
Date: Mon, 5 Feb 2007 14:18:54 -0800
From: Greg KH <greg@kroah.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>, torvalds@osdl.org, akpm@osdl.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/50] -stable review
Message-ID: <20070205221854.GA19345@kroah.com>
References: <20070106022753.334962000@sous-sol.org> <45C624D2.9030403@linuxtv.org> <20070205214332.GB18230@kroah.com> <20070205221233.GU10475@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205221233.GU10475@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 02:12:33PM -0800, Chris Wright wrote:
> * Greg KH (greg@kroah.com) wrote:
> > On Sun, Feb 04, 2007 at 01:24:18PM -0500, Michael Krufky wrote:
> > > At which point was 2.6.18.y dropped?  I thought we were always going to keep
> > > the last two stable kernels up-to-date.
> 
> Not quite.  It's more of a "some overlap," so that as soon as 2.6.x
> comes out we don't instantly drop 2.6.(x-1).y stream.  But we don't keep
> it going, typically more 1 or 2 2.6.(x-1).y releases once 2.6.x is out.
> 
> > > Have I been wasting my time fwd'ing
> > > 2.6.18.y patches?
> 
> I had actually queued them up, but we only had 1 or 2 other patches,
> and they weren't significant enough to warrant flushing that queue.

I'll see if the latest stuff that is queued up and some other stuff is
worth to push out a new release in a few days.

thanks,

greg k-h
