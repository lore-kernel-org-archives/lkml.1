Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbZIHVxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbZIHVxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 17:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbZIHVxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 17:53:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48490 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbZIHVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 17:53:10 -0400
Date: Tue, 8 Sep 2009 23:53:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Andrea Adami <andrea.adami@gmail.com>
Subject: Re: Zaurus suspend saga
Message-ID: <20090908215306.GC17228@elf.ucw.cz>
References: <20090906052653.GB1324@ucw.cz> <1252276145.17852.15.camel@dax.rpnet.com> <20090907113132.GM23450@elf.ucw.cz> <1252329025.1861.6.camel@hammer.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252329025.1861.6.camel@hammer.suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> - It would be nice to have "small travel charger heuristic": Turn fast
> charging on, charger "disappears", switch to slow charging, charger
> "appears" => stay in slow charging mode, and retry after some time, or
> after going to suspend, reset the flag when charger is removed.

Can you try to get that working?

With my AA charger, I get "AC Status: 0", as long as battery is not
full. It draws power for it (and battery percentage goes higher) but
it is not even detected as charger :-(. [But charge LED is lit. WTF?]
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
