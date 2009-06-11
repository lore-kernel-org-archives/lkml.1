Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbZFKOrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbZFKOrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZFKOrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:47:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36274 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbZFKOrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:47:41 -0400
Date: Thu, 11 Jun 2009 16:47:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, swetland@google.com,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611144735.GC2572@ucw.cz>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk> <20090611135442.6b9ab315@lxorguk.ukuu.org.uk> <20090611132134.GA11199@atomide.com> <20090611133736.GP795@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611133736.GP795@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> What you apparantly decided (and I'm saying this from how it appeared
> on the receiving end and sort-of had it confirmed by Kevin in conference)
> is that you'd send a patch set for me to review, I'd review it, and then
> you'd merge it within your git tree into a branch for me.  You'd then do
> the same thing with the next patch set, and so forth.
> 
> Eventually, near the merge window, you sent a pull request for the
> entire lot, by which time I looked at the list of changes and wondered
> whether that encompassed everything you'd asked me to review, or whether
> it contained extra stuff, or whether it was for something quite different,
> or what.

Well, usually Acked-by: and Reviewed-by: tags solve that, no?

If it has my acked-by: it is okay and can be applied. Otherwise I did
not review it before and need to check it...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
