Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYHXU54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYHXU54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 16:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYHXU5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 16:57:47 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57281 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbYHXU5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 16:57:46 -0400
Date: Sun, 24 Aug 2008 21:57:44 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [git pull] drm patches for 2.6.27 final
In-Reply-To: <alpine.LFD.1.10.0808241013510.3363@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.0.82.0808242145350.15834@skynet.skynet.ie>
References: <alpine.DEB.0.82.0808240809170.15834@skynet.skynet.ie>
 <alpine.LFD.1.10.0808241013510.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Quite frankly, I'm not going to take this.
> 
> None of what you describe sounds like regressions, and this is just TOO 
> F*CKING LATE to take big changes like this, to a fragile subsystem that 
> has historically easily introduced new regressions.
> 
> Can you please make a branch with ONLY REGRESSIONS, or fixes for major 
> problems that don't introduce several thousand lines of new code?
> 
> Because you seem to be constantly unable to understand what "merge window" 
> means. And I'm not going to take this kind of crap.

I thought you might say that, I'll re-send with just the ones that fix the 
major issues, instead of ones that fix issues people wanted fixed. Most of 
the real bits were in Rawhide kernels for a few weeks, which tbh kicks the 
ass outta a linux-next/linux-mm test cycle.

Your reply now serves as place to point people at when they ask why Red 
Hat/Fedora ships features that they can't get for 1-6 months, and I'm fine 
with that.

Dave.
