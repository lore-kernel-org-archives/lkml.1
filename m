Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYFQMv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYFQMv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbYFQMvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:51:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2371 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755376AbYFQMvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:51:17 -0400
Date: Tue, 17 Jun 2008 14:51:04 +0200
From: Pavel Machek <pavel@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors@vger.kernel.org, linux-next@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] linux-staging tree created
Message-ID: <20080617125103.GA4211@ucw.cz>
References: <20080610190540.GA25066@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610190540.GA25066@kroah.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> What this tree is not:
> 	- it is not a place to dump code and then run away, hoping that
> 	  someone else will do the cleanup work for you.  While there
> 	  are developers available to do this kind of work, you need to
> 	  get someone to agree to "babysit" the code.

Hmm, how do I tap into that developer pool? :-)

Kohjinsha wifi driver is in state where it was ported to mac80211, and
it still works with minimum features, but it needs dead code removal
and rewriting the rest. That code is really very ugly.

I can do the handholding; I can probably do the rewrite, too (its
10000LoC), but it will take time...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
