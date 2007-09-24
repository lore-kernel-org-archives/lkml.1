Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbXIXOmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbXIXOmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 10:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbXIXOmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 10:42:07 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:59332 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbXIXOmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 10:42:06 -0400
Date: Mon, 24 Sep 2007 15:41:54 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-mac: Driver model & phylib update
In-Reply-To: <20070921124409.7f3d122b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64N.0709241529570.22491@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0709191811040.24627@blysk.ds.pg.gda.pl>
 <20070921124409.7f3d122b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Andrew Morton wrote:

> >  A driver model and phylib update.
> 
> akpm:/usr/src/25> diffstat patches/git-net.patch | tail -n 1
>  1013 files changed, 187667 insertions(+), 23587 deletions(-)
> 
> Sorry, but raising networking patches against Linus's crufty
> old mainline tree just isn't viable at present.

 Well, this is against Jeff's netdev-2.6 tree which hopefully is not as 
crufty as Linus's old mainline; if it is not possible to queue this change 
for 2.6.25 or suchlike, then I will try to resubmit later.  Thanks for 
your attention though.

  Maciej
