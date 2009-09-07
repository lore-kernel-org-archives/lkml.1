Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbZIGKEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbZIGKEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 06:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZIGKEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 06:04:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41540 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZIGKEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 06:04:50 -0400
Date: Mon, 7 Sep 2009 12:04:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       utx@penguin.cz
Subject: Re: Zaurus suspend saga
Message-ID: <20090907100441.GF23450@elf.ucw.cz>
References: <20090906052653.GB1324@ucw.cz> <200909061903.10542.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909061903.10542.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-09-06 19:03:10, Rafael J. Wysocki wrote:
> On Sunday 06 September 2009, Pavel Machek wrote:
> > Hi!
> > 
> > Even with mtd regression fixed, spitz will still not suspend/resume
> > correctly.
> 
> Is the regression fixed in the Linus' tree, or do you still need to apply the
> revert patch?

mtd regression is fixed.

battery vs. SPI regression is very very very old, and seems to be
fixed by the one-liner.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
