Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbZFKNiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbZFKNiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbZFKNh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:37:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48549 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZFKNh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:37:57 -0400
Date: Thu, 11 Jun 2009 14:37:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       swetland@google.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611133736.GP795@n2100.arm.linux.org.uk>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk> <20090611135442.6b9ab315@lxorguk.ukuu.org.uk> <20090611132134.GA11199@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611132134.GA11199@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 06:21:35AM -0700, Tony Lindgren wrote:
> We've done this for two merge windows now for omap patches where the
> patches have been posted to linux-arm-kernel, then they go into the
> for-next tree, and then Russell merges them in.
> 
> It has worked OK, although Russell had some comments about having hard
> time keeping track on what he had reviewed already.

Yes, as I understand it, there was a closed room discussion between
several folk about how you'd handle sending your next round of patches
to me.

What you apparantly decided (and I'm saying this from how it appeared
on the receiving end and sort-of had it confirmed by Kevin in conference)
is that you'd send a patch set for me to review, I'd review it, and then
you'd merge it within your git tree into a branch for me.  You'd then do
the same thing with the next patch set, and so forth.

Eventually, near the merge window, you sent a pull request for the
entire lot, by which time I looked at the list of changes and wondered
whether that encompassed everything you'd asked me to review, or whether
it contained extra stuff, or whether it was for something quite different,
or what.

So by separating the review from the merge by weeks or even months, it
created additional problems.
