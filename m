Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbXFIOvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbXFIOvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 10:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbXFIOvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 10:51:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39277 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751150AbXFIOvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 10:51:21 -0400
Date: Sat, 9 Jun 2007 16:11:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Crispin Cowan <crispin@novell.com>
Cc: Karl MacMillan <kmacmill@redhat.com>, James Morris <jmorris@namei.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
Message-ID: <20070609141159.GA20094@elf.ucw.cz>
References: <20070416213350.GB4030@suse.de> <Line.LNX.4.64.0704161846110.13905@d.namei> <1176846917.5946.79.camel@localhost.localdomain> <4625505C.6010802@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4625505C.6010802@novell.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Some may infer otherwise from your document.
> >>     
> > Not only that, the implication that secrecy is only useful to
> > intelligence agencies is pretty funny.
> That was not the claim. Rather, that intelligence agencies have a very
> strong need for privacy, and will go to greater lengths to get it,
> including using MLS systems. I contend that while most organizations
> want privacy, they don't want it so badly that they will put up with
> MLS, and so are looking for a more tolerable form of security.
> 
> This is relevant here because information flow is the main advantage of
> labels over pathnames for access control. AppArmor does not attempt to
> manage information flow, allowing it to use pathnames to achieve ease of
> use. If you want information flow control, then by all means use a

As SEEdit shows, you can still have ease-of-use with system capable of
MLS.... so don't try to paint is as "pathnames are neccessary so it is
easy to use".

Just extend SELinux to handle new files.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
