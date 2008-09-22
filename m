Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbYIVIAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbYIVIAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 04:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYIVH7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 03:59:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48605 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYIVH7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 03:59:51 -0400
Date: Mon, 22 Sep 2008 08:59:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
Subject: Re: [PATCH 3/5] watchdog: cleanup a bit omap_wdt.c
Message-ID: <20080922075922.GD17746@flint.arm.linux.org.uk>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com> <200809201018.42127.david-b@pacbell.net> <20080920180018.GD9873@flint.arm.linux.org.uk> <200809211845.42990.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809211845.42990.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 06:45:42PM -0700, David Brownell wrote:
> Review rarely happens all at once, unless very few people look at
> the code.  Discouraging review is *extremely* strange.

I'm not discouraging review.  I'm saying that making inappropriate
comments isn't helpful.

Yes, your comments are right, but are they appropriate to getting
the OMAP watchdog drivers updated in mainline, or are they more
appropriate in a general sense to all watchdog drivers, and therefore
should be separate from that task?

> > My point is that we currently have a BIG problem, and that is the OMAP
> > fork being so far out of line with mainline, it isn't funny.
> 
> I call it a "branch" myself; "fork" sounds confrontational.

Call it what you want.

> When more of the arch/arm/* core bits merge -- like the clock and
> power domain updates ISTR you wanted to hold back -- then the rest
> starts to make sense upstream.

I never said that - you're twisting my words as normal.

> Yes, there are two unresolved issues in patch #1 which you seem
> to have successfully buried with your flamage.  Easy fixes, just
> strike a line and truncate a path.  The sort of thing that often
> gets queued in the MM tree as a "fixup" and then merged into a
> main patch.

Yet again you use confrontational language, inflaming this discussion.

Okay, I give up.  Folk here can carry on struggling to get their code
into mainline with endless reviews and getting fed up with having to
constantly rework the code over and over again.

Clearly my views aren't welcome.
