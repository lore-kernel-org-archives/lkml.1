Return-Path: <linux-kernel-owner+w=401wt.eu-S964871AbXCAKWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964871AbXCAKWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 05:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964888AbXCAKWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 05:22:12 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33051 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964885AbXCAKWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 05:22:10 -0500
Date: Thu, 1 Mar 2007 11:21:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301102157.GA20465@elf.ucw.cz>
References: <200702271715.31184.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702271715.31184.a1426z@gawab.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > But it is true that for most kernel programmers, threaded
> > programming is much easier to understand, and we need to engineer the
> > kernel for what will be maintainable for the majority of the kernel
> > development community.
> 
> What's probably true is that, for a kernel to stay competitive you need two 
> distinct traits:
> 
> 1. Stability
> 2. Performance
> 
> And you can't get that, by arguing that the kernel development community 
> doesn't have the brains to code for performance, which I dearly doubt.
> 
> So, instead of using intimidating language to force one's opinion thru, 
> especially when it comes from those in control, why not have a democratic 
> vote?

Linus cast his vote, and as that is only vote that matters, can we end
this discussion? (Eugeny is not willing to listen to Linus, but I
guess that's Eugeny's problem at this point).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
