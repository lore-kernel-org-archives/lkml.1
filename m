Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0BIKJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 05:09:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab0BIKJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 05:09:10 -0500
Date: Tue, 9 Feb 2010 11:09:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       Daniel Mack <daniel@caiaq.de>, Ben Dooks <ben-linux@fluff.org>
Subject: Re: linux-next: manual merge of the trivial tree with the arm tree
In-Reply-To: <20100208154840.a58f46ad.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1002091108080.30967@pobox.suse.cz>
References: <20100208154840.a58f46ad.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> arch/arm/mach-u300/include/mach/debug-macro.S between commit
> 7f62dc4756eaf761570b96250630d48f80397d64 ("ARM: 5910/1: ARM: Add tmp
> register for addruart and loadsp") from the arm tree and commit
> ba5584a307a1166597fbbe970ffdf49c8b7ee42a ("tree-wide: Assorted spelling
> fixes") from the trivial tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks for the fix, I will leave this up to merge with Linus when either I 
or Linus will fix that up.

On Mon, 8 Feb 2010, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in
> arch/arm/plat-s3c64xx/irq.c between commit
> 51022cf6591ae2945960d034788bdeffa28cde13 ("ARM: SAMSUNG: Move IRQ UART
> handling for newer devices to plat-samsung") from the arm tree and commit
> ba5584a307a1166597fbbe970ffdf49c8b7ee42a ("tree-wide: Assorted spelling
> fixes") from the trivial tree.
> 
> The former removes the comment updated by the latter.

Removed the hunk, thanks.

On Mon, 8 Feb 2010, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> arch/arm/plat-s5pc1xx/irq.c between commit
> be97162d47b2e067f9d21097650f2f0405dacc9f ("ARM: S5PC1XX: Use common UART
> IRQ handling code") from the arm tree and commit
> ba5584a307a1166597fbbe970ffdf49c8b7ee42a ("tree-wide: Assorted spelling
> fixes") from the trivial tree.
> 
> The former removes the comment updated by the latter.

Removed this one as well.

Thanks!

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
