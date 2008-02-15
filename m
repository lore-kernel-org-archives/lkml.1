Return-Path: <linux-kernel-owner+w=401wt.eu-S1763926AbYBOKAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763926AbYBOKAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 05:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbYBOKAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 05:00:12 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4174 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbYBOKAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 05:00:10 -0500
Date: Fri, 15 Feb 2008 10:01:09 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 15
Message-ID: <20080215100109.GD24479@shadowen.org>
References: <20080215183143.c811803c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215183143.c811803c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 06:31:43PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.
> 
> Between each merge, the tree was built with allmodconfig for both
> powerpc and x86_64.
> 
> You can see which trees have been included by looking in the Trees file
> in the source.
> 
> The tree is now tagged with a tag like next-YYYYMMDD and has a
> localversion-next file which adds "-next-YYYYMMDD" to the kernel revision.

Thats cool except that the tags seem to be missing in your public tree.
Tags do not get pushed automatically, you have to push them manually,
perhaps they were missed?

> There were a couple of merge conflicts and one build failure and the
> appropriate people contacted.
> 
> We are up to 18 trees, more are welcome.

-apw
