Return-Path: <linux-kernel-owner+w=401wt.eu-S1750961AbXDDSi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961AbXDDSi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbXDDSh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:37:58 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:44902 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbXDDShl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:37:41 -0400
Date: Wed, 4 Apr 2007 11:39:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/90] Post 2.6.21 OMAP update
Message-Id: <20070404113925.da221efc.randy.dunlap@oracle.com>
In-Reply-To: <20070404182728.GK29129@atomide.com>
References: <11757088774110-git-send-email-tony@atomide.com>
	<20070404182728.GK29129@atomide.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 14:27:30 -0400 Tony Lindgren wrote:

> * Tony Lindgren <tony@atomide.com> [070404 14:02]:
> > Hi all,
> > 
> > Attached is a rather large OMAP update for post 2.6.21.
> > 
> > OMAP is a series of ARM processors from Texas Instruments
> > used in various cell phones and PDAs.
> > 
> > The patch series is based on code that has been brewing
> > in the linux-omap tree since last fall.
> > 
> > We'd like to switch the linux-omap tree to use the mainline
> > tree for core omap stuff, and this series attemps to do it
> > for most part. 
> > 
> > As the patch series is big, Andrew Morton asked me to post
> > it to LKML instead of linux-arm-kernel list for a wider review,
> > so please comment on the patches if you have a chance!
> > 
> > The patches touch only omap specific code at:
> > 
> > arch/arm/Kconfig
> > arch/arm/plat-omap
> > arch/arm/mach-omap1
> > arch/arm/mach-omap2
> > include/asm-arm/arch-omap
> 
> Looks like using git-send-email --chain-reply-to with this many
> messages is not a good idea... The threading gets nested too wide :)

That's only a problem when there are <too many> patches to be
reviewed.  Hence, do more frequent postings of fewer patches per series.
That will likely also get you more reviewers.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
