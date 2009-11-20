Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbZKTSYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbZKTSYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZKTSYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:24:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35113 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZKTSYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:24:11 -0500
Date: Fri, 20 Nov 2009 19:24:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Paul Parsons <lost.distance@yahoo.com>, linux-input@vger.kernel.org,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, linux-kernel@vger.kernel.org,
       Dirk@Opfer-Online.de, arminlitzel@web.de, metan@ucw.cz,
       thommycheck@gmail.com, linux-arm-kernel@lists.infradead.org,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: Re: [PATCH] hx4700: fix hx4700 touchscreen pressure values
Message-ID: <20091120182405.GA1378@ucw.cz>
References: <E1NAYJo-00016g-PW@pih-relay04.plus.net> <20091118172849.GD25150@elf.ucw.cz> <20091118173934.GA4458@core.coreip.homeip.net> <20091118174649.GB4458@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118174649.GB4458@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Dmitry, those pressure values are reverted on more than one machine,
> > > and we do not have anyone reporting it works ok for them. Can we
> > > perhaps just.... fix it?
> > 
> > OK, so we have 4 instances where pressure is inverted and nobody wants
> > to come out with a non-inverted example... I'll queue for .33 then - .32
> > it too close to the release.
> > 
> 
> Btw, could you send me the latest version of your patch please?

Yep, resent in separate mail.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
