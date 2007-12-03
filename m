Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbXLCOjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbXLCOjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 09:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXLCOjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 09:39:35 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:49280 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752087AbXLCOjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 09:39:35 -0500
Date: Mon, 3 Dec 2007 14:39:26 +0000
From: Ben Dooks <ben@fluff.org>
To: Matt Porter <mporter@kernel.crashing.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>, Vitaly Luban <vitaly@luban.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Tokyo Electron SDIO controller (Ellen) support
Message-ID: <20071203143926.GC7855@fluff.org.uk>
References: <47511ADA.20506@luban.org> <20071201215010.2fa3b334@poseidon.drzeus.cx> <20071203142207.GA28101@gate.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203142207.GA28101@gate.crashing.org>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 08:22:07AM -0600, Matt Porter wrote:
> On Sat, Dec 01, 2007 at 09:50:10PM +0100, Pierre Ossman wrote:
> > As for the patch, it's a big NAK at this point. Vendors who can't be bothered to follow
> > the standard will have to wait for Ben's separation patches before they can be supported.
> > Then they can have some voodoo front-end to handle their mistakes instead of turning
> > sdhci.c into a collection of hacks and workarounds.
> 
> What's the status of Ben's separation patches? I haven't seen a posting of those
> versus a recent kernel. I've got some SDHCI driver glue for the non-pci Arasan core
> running in an older kernel tree with those patches. It's just waiting for the separation
> patches to hit the mmc or mainline tree.

I need to go back and try and sort out the last of Pierre's last
comments, and update to the latest kernel version. I was waiting
for 2.6.24-rc4 to re-start the effort to try and ensure there are
fewer changes due to fixes.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
