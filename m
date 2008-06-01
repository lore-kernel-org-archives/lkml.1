Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbYFAQKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbYFAQKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYFAQKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:10:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3764 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750936AbYFAQKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:10:10 -0400
Date: Sun, 1 Jun 2008 18:09:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lars Noschinski <lars@public.noschinski.de>
Cc: Jiri Kosina <jkosina@suse.cz>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       ksummit-2008-discuss@lists.linux-foundation.org, penberg@cs.helsinki.fi,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: store-same-blocksonce (was Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project)
Message-ID: <20080601160950.GA5555@ucw.cz>
References: <1212010931.3445.103.camel@localhost.localdomain> <1212013125.2236.58.camel@shinybook.infradead.org> <1212014127.3445.115.camel@localhost.localdomain> <20080528.230934.131215087.davem@davemloft.net> <1212071813.3428.22.camel@localhost.localdomain> <Pine.LNX.4.64.0805291656000.6718@jikos.suse.cz> <20080531192120.GA6843@lars.home.noschinski.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531192120.GA6843@lars.home.noschinski.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The project I was later involved on was writing a file 
> system, which
> stores blocks with the same content only once. In a two 
> months period
> (with other lectures to attend to), we managed to 
> produce such a thing;
> but it was very unreliable (which reminds me, I am 
> supposed to publish
> the results of this project here)

Yep, sounds like a cool project, actually. I guess it could be very
useful for people like me that store many kernel trees around, and
sometimes run out of  disk space.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
