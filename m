Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbYCPNhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbYCPNhA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 09:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYCPNgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 09:36:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43909 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751861AbYCPNgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 09:36:52 -0400
Date: Sun, 16 Mar 2008 13:14:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: Willy Tarreau <w@1wt.eu>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080316131449.7d114d37@the-village.bc.nu>
In-Reply-To: <200803152033.08788.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<200803151533.10797.phillips@phunq.net>
	<20080315232221.GA24227@1wt.eu>
	<200803152033.08788.phillips@phunq.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anecdote time.  Remember there used to be "brand name" floppy disks and
> generic floppy disks, and the brand name ones cost a lot more because
> they were supposedly safer?  Well, big secret, studies were done and
> the no-name disks came out better.  Why?  Because selling at commodity
> prices the generic makers could not afford returns.  So they made them
> well.

Which is not the case for PCs
> 
> It is like that with PCs.  

Nope.

> when you spend more money and buy all high end near-custom gear.  In
> fact, the cheap stuff just keeps on chugging, because those guys can't
> afford to have it break.

They don't care if it breaks after 12 months, and for components and
addons they don't care if it breaks, they just blame the end user for
mis-installation or 'incompatibility'. There is a huge difference in
quality between high end server boards and cheap desktop PC systems.

> Right.  What we are talking about is filling in a missing level in the
> cache hierarchy, something like:

Perhaps. But if your cache can destroy the contents of the layer below in
situations that do occur it isn't useful. If you can fix that then it
obviously has a lot of potential.

Alan
