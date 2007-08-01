Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbXHBPsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbXHBPsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXHBPse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:48:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4351 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758138AbXHBPsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:48:33 -0400
Date: Wed, 1 Aug 2007 09:22:28 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Miklos Szeredi <miklos@szeredi.hu>, jbms@cmu.edu, nigel@nigel.suspend2.net,
       miltonm@bga.com, stern@rowland.harvard.edu, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: Hibernation considerations
Message-ID: <20070801092227.GB4808@ucw.cz>
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm> <87lkd9ohtn.fsf@jbms.ath.cx> <E1ICJRG-0000OG-00@dorka.pomaz.szeredi.hu> <200707212120.04645.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707212120.04645.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Hmm, wonder why this isn't affecting people with VPNs?  Probably
> > network mounts over VPN are rare, and ever rarer to have fs activity
> > on them during suspend.
> > 
> > Anyway, I think it's long overdue to stop thinking about how to "fix"
> > fuse, and concentrate on fixing the underlying problem instead ;)
> 
> To conclude this branch of the thread, I have a patch in the works that may
> help a bit with unfreezable FUSE filesystems and it only affects the freezer.
> I'll post it when 2.6.23-rc1 is out, because it's on top of some other patches
> that need to go first.

I'm interested... which one is that?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
