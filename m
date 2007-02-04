Return-Path: <linux-kernel-owner+w=401wt.eu-S1750912AbXBDA7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912AbXBDA7w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 19:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbXBDA7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 19:59:52 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52688 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750912AbXBDA7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 19:59:51 -0500
Date: Sun, 4 Feb 2007 01:59:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel list <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx
Subject: Re: [Sdhci-devel] x60: mmc card reader problem
Message-ID: <20070204005941.GA7978@elf.ucw.cz>
References: <20070203002443.GA3031@elf.ucw.cz> <45C502C6.1090304@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C502C6.1090304@drzeus.cx>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ...it wants me to report:
> > 
> > 
> > ...yes, I yanked the card when I seen "unknown partition table".
> > 
> > (This is how it looks on debug console; it captured the dumps, too:)
> 
> Error 1 is timeout, which can be caused by many things. Have you tried
> with several cards? And is it repeatable?

Not repeatable, sorry :-(.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
