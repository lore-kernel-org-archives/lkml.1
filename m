Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207Ab0CAJjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:39:55 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46980 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab0CAJjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:39:53 -0500
Date: Mon, 1 Mar 2010 09:39:22 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Kukjin Kim <kgene.kim@samsung.com>,
       Adityapratap Sharma <aditya.ps@samsung.com>,
       Atul Dahiya <atul.dahiya@samsung.com>
Subject: Re: linux-next: manual merge of the samsung tree with the arm tree
Message-ID: <20100301093922.GA16639@flint.arm.linux.org.uk>
References: <20100225104819.6d117587.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225104819.6d117587.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 10:48:19AM +1100, Stephen Rothwell wrote:
> Hi Ben,
> 
> Today's linux-next merge of the samsung tree got a conflict in
> arch/arm/mach-s5p6442/include/mach/debug-macro.S between commit
> 4e6d488af37980d224cbf298224db6173673f362 ("ARM: 5910/1: ARM: Add tmp
> register for addruart and loadsp") from the arm tree and commit
> 5f7f6a4a0df9b43051d57fdb8ea96c083247a08f ("ARM: S5P6442: Add Samsung
> S5P6442 CPU support") from the samsung tree.

You're getting this because I've dropped the branch containing all the
trees I'd merged over the last 3 months from the branch(es) you pull.

The PXA folk decided to rebase their tree and send Linus some of their
original commits independently of their previous pull - and their tree
was the first to be merged.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
