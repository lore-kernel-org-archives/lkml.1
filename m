Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZK2JQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZK2JQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 04:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZK2JQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 04:16:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42059 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbZK2JQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 04:16:45 -0500
Date: Sun, 29 Nov 2009 10:16:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: Re: [patch] spitz: better voltage-to-percentage conversion
Message-ID: <20091129091639.GA3483@ucw.cz>
References: <20091127073119.GB1405@ucw.cz> <20091127085417.GB27009@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091127085417.GB27009@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +
> > +typedef int miliamp_t;
> > +typedef int miliohm_t;
> > +typedef int milivolt_t;
> 
> 'milliamp' 'milliohm' 'millivolt'

Thanks, updated patch follows.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
