Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbXJXXbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbXJXXbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbXJXXbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:31:33 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38699 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754126AbXJXXbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:31:31 -0400
Date: Thu, 25 Oct 2007 01:32:00 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Simon Arlott <simon@fire.lp0.eu>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
	static interface)
Message-ID: <20071024233200.GJ30533@stusta.de>
References: <20071024223124.GI30533@stusta.de> <446110.89443.qm@web36608.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <446110.89443.qm@web36608.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 03:58:02PM -0700, Casey Schaufler wrote:
> 
> --- Adrian Bunk <bunk@kernel.org> wrote:
> 
> > ...
> > 
> > There are other points in this thread that might or might not warrant 
> > making LSM modular again, but even though it might sound harsh breaking 
> > external modules and thereby making people aware that their code should 
> > get into the kernel is IMHO a positive point.
> 
> Those proposing LSM modules over the past couple years have
> been treated most harshly. I have personally taken the least
> flak of anyone on my proposal, and at that there have been
> times where I felt like pulling out the #5 clue stick and
> taking a few swings. It's no wonder that people are afraid
> to suggest a module. I didn't do it until I had combed through
> the archives and prepared answers for the most common attacks.
> I hope that Smack moving forward will defuse some of the bad
> vibes that have clouded the LSM for so long. I don't blame
> anyone who kept their module to themself given the hostility
> which even successful products have encountered.
> 
> And don't give me the old "LKML is a tough crowd" feldercarb.
> Security modules have been much worse. Innovation, even in
> security, is a good thing and treating people harshly, even
> "for their own good", is an impediment to innovation.

What I'm giving you is "Linus has decreed there can be LSMs other than 
SELinux."

Getting LSMs included should no longer be harder than for other 
parts of the kernel.

And don't get me wrong, I'm not saying my point should decide this 
discussion. It's simply the point that making it harder for external 
code also has advantages.

> Casey Schaufler

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

