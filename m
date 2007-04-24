Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbXDXUlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbXDXUlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbXDXUls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:41:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59402 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754541AbXDXUls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:41:48 -0400
Date: Tue, 24 Apr 2007 22:41:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [PATCH 3/7] Universal battery class
Message-ID: <20070424204108.GC16457@elf.ucw.cz>
References: <20070420115813.GC21752@zarina> <20070424192846.GA16503@elf.ucw.cz> <20070424203251.GA23688@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424203251.GA23688@zarina>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > 
> > > Signed-off-by: Anton Vorontsov <cbou@mail.ru>
> > 
> > Yes please. Generic battery support is badly needed.
> 
> I'm glad you like it, thanks for the review!
> 
> Also I've done some code split. It removes all #ifdefs from battery.c,
> and also separates core from sysfs and leds.
> 
> If there will no objections, I'll send this version when patch window
> will opened.

Actually, you probably want to add some changelogs, and send it to
akpm _now_. He'll merge it to -mm tree, and hopefully send it upstream
in the next window. Merging directly to linus is for bigger projects
with git trees etc.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
