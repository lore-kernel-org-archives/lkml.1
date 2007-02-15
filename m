Return-Path: <linux-kernel-owner+w=401wt.eu-S1422726AbXBOXuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422726AbXBOXuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422725AbXBOXuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:50:06 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53041 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422700AbXBOXuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:50:04 -0500
Date: Fri, 16 Feb 2007 00:49:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Zachary Amsden <zach@vmware.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
Message-ID: <20070215234943.GC4176@elf.ucw.cz>
References: <200702060353.l163rUmj000771@zach-dev.vmware.com> <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com> <20070207123552.GD4481@ucw.cz> <1170880572.11736.4.camel@localhost.localdomain> <20070214125216.2befda78@localhost.localdomain> <45D36B49.5090109@vmware.com> <20070215101713.GK26240@elf.ucw.cz> <45D4F003.4030502@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D4F003.4030502@vmware.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >You know it is ugly. Alan demonstrated it even hurts performance, but
> >being ugly is the main problem.
> >  
> 
> No argument with that.  Well, we're ok with dropping it.  Actually, 
> reverting the entire set of udelay changes now seems wise.  The same
>bug

Good, thanks.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
