Return-Path: <linux-kernel-owner+w=401wt.eu-S1764299AbXGVVNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764299AbXGVVNt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 17:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbXGVVNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 17:13:40 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:37369 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbXGVVNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 17:13:39 -0400
Date: Mon, 23 Jul 2007 06:13:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jon Smirl <jonsmirl@gmail.com>, Git Mailing List <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Git tree for old kernels from before the current tree
Message-ID: <20070722211314.GA13850@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Jon Smirl <jonsmirl@gmail.com>,
	Git Mailing List <git@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com> <Pine.LNX.4.64.0707222257540.32367@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707222257540.32367@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 11:00:15PM +0200, Jan Engelhardt wrote:
> On Jul 22 2007 16:49, Jon Smirl wrote:
> > Continuing on with kernel archeology for embedded systems, any
> > interest in making a git tree with all of the kernel versions from the
> > beginning up to the start of the current git tree?
> 
> Well, it would be cool if history was somehow available (I recognize
> this would be a lot of work). One currently has to go through the
> bk repo if something is to be searched for in that timeframe.
> 
Err, that's crap. Have you even looked at gitweb? There's at least:

git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git

This has trees all the way back to 2.5.0.

and Linus also has:

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/old-2.6-bkcvs.git

for the BK history.

That's already more history than most people have any immediate use for,
going beyond that starts getting in to general completeness before
practical application territory.

Anyone still sending 2.4 patches with the intent of them being moved
forward and applied to a current kernel needs to be killfiled.
