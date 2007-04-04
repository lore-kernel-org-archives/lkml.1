Return-Path: <linux-kernel-owner+w=401wt.eu-S1751229AbXDDSpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbXDDSpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXDDSpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:45:22 -0400
Received: from nlpi043.sbcis.sbc.com ([207.115.36.72]:50874 "EHLO
	nlpi043.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbXDDSpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:45:19 -0400
X-ORBL: [67.117.73.34]
Date: Wed, 4 Apr 2007 14:44:57 -0400
From: Tony Lindgren <tony@atomide.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/90] Post 2.6.21 OMAP update
Message-ID: <20070404184455.GL29129@atomide.com>
References: <11757088774110-git-send-email-tony@atomide.com> <20070404182728.GK29129@atomide.com> <20070404113925.da221efc.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404113925.da221efc.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap <randy.dunlap@oracle.com> [070404 14:37]:
> On Wed, 4 Apr 2007 14:27:30 -0400 Tony Lindgren wrote:
> 
> > * Tony Lindgren <tony@atomide.com> [070404 14:02]:
> > > Hi all,
> > > 
> > > Attached is a rather large OMAP update for post 2.6.21.
> > > 
> > > OMAP is a series of ARM processors from Texas Instruments
> > > used in various cell phones and PDAs.
> > > 
> > > The patch series is based on code that has been brewing
> > > in the linux-omap tree since last fall.
> > > 
> > > We'd like to switch the linux-omap tree to use the mainline
> > > tree for core omap stuff, and this series attemps to do it
> > > for most part. 
> > > 
> > > As the patch series is big, Andrew Morton asked me to post
> > > it to LKML instead of linux-arm-kernel list for a wider review,
> > > so please comment on the patches if you have a chance!
> > > 
> > > The patches touch only omap specific code at:
> > > 
> > > arch/arm/Kconfig
> > > arch/arm/plat-omap
> > > arch/arm/mach-omap1
> > > arch/arm/mach-omap2
> > > include/asm-arm/arch-omap
> > 
> > Looks like using git-send-email --chain-reply-to with this many
> > messages is not a good idea... The threading gets nested too wide :)
> 
> That's only a problem when there are <too many> patches to be
> reviewed.  Hence, do more frequent postings of fewer patches per series.
> That will likely also get you more reviewers.

Yeah, I agree.. We've already missed two merge windows because of the
large patch set :( The problem is that patch set just keeps growing.

Things should be to normal small patch sets once this pile is dealt
with.

Regards,

Tony
