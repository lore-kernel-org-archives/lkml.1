Return-Path: <linux-kernel-owner+w=401wt.eu-S966751AbXEGUjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966751AbXEGUjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966747AbXEGUjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:39:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34891 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966737AbXEGUjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:39:07 -0400
Date: Mon, 7 May 2007 22:38:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Oliver Neukum <oneukum@suse.de>,
       David Lang <david.lang@digitalinsight.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070507203859.GB18400@elf.ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <Pine.LNX.4.63.0705061909290.19118@qynat.qvtvafvgr.pbz> <20070507124818.GA18209@elf.ucw.cz> <200705071452.21969.oneukum@suse.de> <Pine.LNX.4.64.0705070736010.18013@asgard.lang.hm> <20070507195142.GC3981@ucw.cz> <Pine.LNX.4.64.0705071250460.21621@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705071250460.21621@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I don't dispute that it sometimes works today.
> 
> what I dispute is that makeing it work should be a contraint on a cleaner 
> design that happens to cause tcp connections to fail on suspend-to-disk 
> (hibernate).
> 
> if you are dong suspend-to-disk for such a short period that TCP 
> connections are able to recover (typically <15 min for most firewalls, in 
> some cases <2 min for connections with keep-alive) is it really
> worth it?

People were using swsusp to move server from one room to another.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
