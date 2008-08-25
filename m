Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbYHYGuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbYHYGuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 02:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYHYGu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 02:50:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:44613 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYHYGu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 02:50:26 -0400
Subject: Re: [git pull] drm patches for 2.6.27 final
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Airlie <airlied@linux.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
In-Reply-To: <alpine.DEB.0.82.0808242145350.15834@skynet.skynet.ie>
References: <alpine.DEB.0.82.0808240809170.15834@skynet.skynet.ie>
	 <alpine.LFD.1.10.0808241013510.3363@nehalem.linux-foundation.org>
	 <alpine.DEB.0.82.0808242145350.15834@skynet.skynet.ie>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 08:49:06 +0200
Message-Id: <1219646946.20732.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-24 at 21:57 +0100, Dave Airlie wrote:
> > Quite frankly, I'm not going to take this.
> > 
> > None of what you describe sounds like regressions, and this is just TOO 
> > F*CKING LATE to take big changes like this, to a fragile subsystem that 
> > has historically easily introduced new regressions.
> > 
> > Can you please make a branch with ONLY REGRESSIONS, or fixes for major 
> > problems that don't introduce several thousand lines of new code?
> > 
> > Because you seem to be constantly unable to understand what "merge window" 
> > means. And I'm not going to take this kind of crap.
> 
> I thought you might say that, I'll re-send with just the ones that fix the 
> major issues, instead of ones that fix issues people wanted fixed. Most of 
> the real bits were in Rawhide kernels for a few weeks, which tbh kicks the 
> ass outta a linux-next/linux-mm test cycle.
> 
> Your reply now serves as place to point people at when they ask why Red 
> Hat/Fedora ships features that they can't get for 1-6 months, and I'm fine 
> with that.

6 months sounds too long, there's at least one merge window in such a
time-frame.



