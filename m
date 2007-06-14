Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbXFOMcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbXFOMcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXFOMcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:32:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1833 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752056AbXFOMcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:32:12 -0400
Date: Thu, 14 Jun 2007 17:01:44 +0000
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Sean <seanlkml@sympatico.ca>, Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,pathname matching
Message-ID: <20070614170144.GD9442@ucw.cz>
References: <Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm> <200706091101.JAB31303.PTNNSGtM@I-love.SAKURA.ne.jp> <20070608232531.d68de09f.seanlkml@sympatico.ca> <Pine.LNX.4.64.0706082138360.6675@asgard.lang.hm> <20070609011022.ac332fc7.seanlkml@sympatico.ca> <Pine.LNX.4.64.0706082224370.6675@asgard.lang.hm> <20070609014454.2f1f2f91.seanlkml@sympatico.ca> <Pine.LNX.4.64.0706082356220.6675@asgard.lang.hm> <20070609032822.bc420a84.seanlkml@sympatico.ca> <Pine.LNX.4.64.0706090030470.6675@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706090030470.6675@asgard.lang.hm>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I also don't care about the details of how it gets 
> implemented, but when the AA people have a working 
> implementation, and the SELinux people are strongly 
> opposed to the concept, I don't see any advantage in 

Actually, SELinux people 'liked' the concept -- they are willing to
extend SELinux to handle new files better. And not only SELinux people
are opposed to AA.

> if the SELinux people had responded to the announcement 
> of AA with "that's a nice idea, if we add these snippits 
> from your code to SELinux then we can do the same thing" 
> it would be a very different story.

It was something like 'is there description of AA security model? We'd
like to take a look if we can do that within SELinux'. I tried to
forward them pdf, but it was more AA implementation description (not
AA model description) so it was probably not helpful.

So yes, SELinux people want to help.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
