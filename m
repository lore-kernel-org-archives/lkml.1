Return-Path: <linux-kernel-owner+w=401wt.eu-S1030503AbXDMXuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030503AbXDMXuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030899AbXDMXuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:50:10 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49914 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030503AbXDMXuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:50:09 -0400
Date: Sat, 14 Apr 2007 01:50:17 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz
Cc: linux-pm@lists.osdl.org
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070413235017.GR5907@stusta.de>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070413212954.GA2545@melchior.yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070413212954.GA2545@melchior.yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 11:29:55PM +0200, Tobias Diedrich wrote:
> Linus Torvalds wrote:
> 
> > We should be getting close to a 2.6.21 release, so please update any 
> > regression reports you've done,
> 
> For me, suspend to disk works only once (has been the case for all
> .21-rcs IIRC, but I didn't get around to report it so far).
> There are some threads about an issue like this, which is supposed
> to be fixed by disabling CONFIG_PCI_MSI, but on my system the
> problem persists nonetheless.
> 
> On the second suspend attempt, the last message I see is
> "Suspending console(s)"
> 
> If I find the time, I'll try to bisect it this weekend.
>...

Does CONFIG_HPET_TIMER=n make any difference?
Does the latest -git work?
 
cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

