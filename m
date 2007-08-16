Return-Path: <linux-kernel-owner+w=401wt.eu-S1764211AbXHPR2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764211AbXHPR2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 13:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758423AbXHPR2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 13:28:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37081 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408AbXHPR17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 13:27:59 -0400
Date: Thu, 16 Aug 2007 10:23:54 -0700
From: Greg KH <greg@kroah.com>
To: Thorsten Leemhuis <fedora@leemhuis.info>
Cc: Willy Tarreau <w@1wt.eu>, stable@kernel.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [stable] no announce mails for "older" stable-releases on
	linux-kernel-announce (Was: Re: Linux 2.6.20.16)
Message-ID: <20070816172354.GA18661@kroah.com>
References: <20070816054357.GA22242@hera.kernel.org> <46C3EAB7.2000503@leemhuis.info> <20070816062908.GA1620@1wt.eu> <46C3F1D5.9040604@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C3F1D5.9040604@leemhuis.info>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 08:42:29AM +0200, Thorsten Leemhuis wrote:
> On 16.08.2007 08:29, Willy Tarreau wrote:
> > On Thu, Aug 16, 2007 at 08:12:07AM +0200, Thorsten Leemhuis wrote:
> >> On 16.08.2007 07:43, Willy Tarreau wrote:
> >>> I've just released Linux 2.6.20.16. This version catches up with 2.6.21.7.
> >>> I hope to issue newer releases soon with next batches of pending patches.
> >>>
> >>> I'll also be replying to this message with a copy of the patch between
> >>> 2.6.20.15 and 2.6.20.16.
> >>> [...]
> >> Just wondering -- Kernels like this (or 2.6.16.x, 2.6.21.x as well as
> >> 2.6.22.x once 2.6.23 got released) don't get announced on
> >> linux-kernel-announce. Is that on purpose or a misbehavior of scripts
> >> that create the messages for linux-kernel-announce?
> > even simpler : I've never been aware of linux-kernel-announce. It's
> > possible that only Linus sends there and that even the -stable team
> > does not use/know about it either.
> 
> Mails for the current stable-releases get out there -- e.g. I received a
> "Linux kernel 2.6.22.3 released" not that long ago (that particular one
> was broken, but that's another story mentioned somewhere else on LKML
> already).
> 
> If just seems that 2.6.21.x (or 2.6.20.x or 2.6.16.x) don't get
> mentioned on the list because some script likely does a check like this:
> 
> if 2.6.22.3 > 2.6.20.16;
> then
> 	# don't send mail
> 	exit
> fi
> 
> >> > If the latter: are those scripts available somewhere?
> > we all have somewhat different scripts. [...]
> 
> I tend to think it's a script that runs on a server site somewhere to
> generates those mails, as they contain the text:

Yes, it's something on kernel.org, I don't do anything to generate a
message to be sent on the -announce mailing list.

Perhaps you need to ask the kernel.org maintainers about this.

thanks,

greg k-h
