Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYLKPVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYLKPVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 10:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbYLKPUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 10:20:54 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33467 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbYLKPUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 10:20:54 -0500
Date: Thu, 11 Dec 2008 16:20:45 +0100
From: Pavel Machek <pavel@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081211152045.GB1842@ucw.cz>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-12-10 17:04:39, Linus Torvalds wrote:
> 
> Nothing overly exciting here. Lots of small things, mostly in drivers 
> (with some defconfig updates for m68k and mips making the diffs bigger). 
> 
> There's some uncomfortably big changes to the intel DRI code, but most of 
> that is all about fixes to the new i916 "GEM" code that is only used by 
> development X servers, and is a new feature, so it shouldn't be able to 
> cause regressions.
> 
> Perhaps more interesting is simply the release scheduling issue. I'm 
> getting slowly ready to do a real 2.6.28, but I don't think anybody really 
> wants the merge window to be around the holidays. So the question is 
> really whether to 
> 
>  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after xmas
> 
>      I like this, because alledgely people are debugging things, and we'd 
>      get a more stable 2.6.28.
> 
> or
> 
>  (b) release in a week or two, but just allow for possibly extending the 
>      merge window due to people being drunk on eggnog..
> 
>      I like this because let's face it, we get more and better bug 
>      information after releases, and everything _should_ be ready for 
>      merging *before* the merge window anyway.

I like (b)... to have some more interesrting holidays :-).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
