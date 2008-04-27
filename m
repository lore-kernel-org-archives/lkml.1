Return-Path: <linux-kernel-owner+w=401wt.eu-S1765924AbYD1Ghd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765924AbYD1Ghd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbYD1GhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:37:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4308 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755149AbYD1GhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:37:25 -0400
Date: Sun, 27 Apr 2008 19:25:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk
Subject: Re: CONFIG_OPTIMIZE_INLINING
Message-ID: <20080427172542.GA5485@ucw.cz>
References: <20080426.215513.141243565.davem@davemloft.net> <20080427055943.GA16290@elte.hu> <20080426.230807.144232984.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.230807.144232984.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ... as i saw no reason why this feature, which i found rather useful, 
> > should be delayed another year or so. I'd be more than happy to promote 
> > this feature back to lib/Kconfig.debug, sparc64 interest would make that 
> > a strong argument.
> 
> So you caved in to FUD in order to pad your commit and signoff count?
> 
> Because anyone who is paying attention can see clearly that you're
> trying to push as much stuff as quickly as possible into Linus's tree
> with your singoffs and authorship on it this merge window.
> 
> Gee, I wonder why...

What is going on here?

Yes, Ingo wants to merge a lots of stuff so that he does not have to
maintain it for two more months. That's the result of 14-days merge
window decission. ... 

No, I don't like that, either, but I don't think you can blame Ingo
for the merge window.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
