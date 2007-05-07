Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbXEGTv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbXEGTv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXEGTvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:51:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3179 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754790AbXEGTvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:51:54 -0400
Date: Mon, 7 May 2007 19:51:42 +0000
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
Message-ID: <20070507195142.GC3981@ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <Pine.LNX.4.63.0705061909290.19118@qynat.qvtvafvgr.pbz> <20070507124818.GA18209@elf.ucw.cz> <200705071452.21969.oneukum@suse.de> <Pine.LNX.4.64.0705070736010.18013@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705070736010.18013@asgard.lang.hm>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>Really? It works today... if the suspend is short 
> >>enough. And that's
> >>how it should be.
> >
> >If we get very good at Wake-on-Lan it should work for 
> >any length
> >of time.
> 
> for suspend-to-ram this would work, I stand corrected.
> 
> for hibernate this would almost certinly not work, and I 
> don't think that it's worth raising false hopes.

Check the facts. It used to work, and it should work today.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
