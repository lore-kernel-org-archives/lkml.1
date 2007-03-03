Return-Path: <linux-kernel-owner+w=401wt.eu-S1030680AbXCCQXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030680AbXCCQXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 11:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030681AbXCCQXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 11:23:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56042 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030680AbXCCQXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 11:23:18 -0500
Date: Sat, 3 Mar 2007 16:23:12 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Richard Purdie <rpurdie@rpsys.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, romosan@sycorax.lbl.gov,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [Linux-fbdev-devel] 2.6.21-rc2 radeon backlight
In-Reply-To: <1172878812.11149.207.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703031619360.5722@pentafluge.infradead.org>
References: <20070301184531.b3aeafe3.akpm@linux-foundation.org> 
 <87tzx35zkc.fsf@sycorax.lbl.gov>  <20070302122920.a2967ebf.akpm@linux-foundation.org>
  <20070302.123514.35465791.davem@davemloft.net> 
 <Pine.LNX.4.64.0703022131310.6960@pentafluge.infradead.org> 
 <20070302135841.fbfc1e32.akpm@linux-foundation.org>
 <1172878812.11149.207.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Sorry, but my confidence level on this one is very low.  We've had heaps
> > and heaps of Kconfig-related build errors in exactly this area.  I'd prefer
> > that a patch like this one have a lot of testing and review (and a
> > changelog?) before we let it near a tree.
> 
> Agreed, I can tell from what I've seen so far this will at least break
> the PMAC users...
> 
> See my proposed patch, if that doesn't work, we should revert the
> problematic change.

I will ask work if I can take home a LCD monitor with a backlight to 
find the real problem and fix. I wouldn't be able to do that until next 
weekend. So take what ever patch Rich sends.

