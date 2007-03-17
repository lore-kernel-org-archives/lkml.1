Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbXCQXqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbXCQXqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 19:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbXCQXqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 19:46:43 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33850 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751696AbXCQXqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 19:46:42 -0400
Date: Sun, 18 Mar 2007 00:46:44 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc4
Message-ID: <20070317234644.GN752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <45FAD77A.1070709@googlemail.com> <s5hbqitj9xi.wl%tiwai@suse.de> <6bffcb0e0703161203v699d9b21x8fa6bf5175916441@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6bffcb0e0703161203v699d9b21x8fa6bf5175916441@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 08:03:29PM +0100, Michal Piotrowski wrote:
> On 16/03/07, Takashi Iwai <tiwai@suse.de> wrote:
> >At Fri, 16 Mar 2007 18:44:26 +0100,
> >Michal Piotrowski wrote:
> >>
> >> Takashi, unfortunately this bug isn't fixed
> >> http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1684
> >
> >The patch wasn't merged to rc4.
> 
> I know. I use patched 2.6.21-rc3-git4 for crashdump.
> 
> >Or, do you mean the bug is still present even with the patch?
> 
> This patch doesn't fix the problem.
> http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/3080.html
> 
> Tomorrow, I'll try to provide more info about this problem.

You said at [1] that the patch from [2] (not yet merged into Linus' tree) 
fixed this problem for you.

Or do I confuse anything?

> Regards,
> Michal

cu
Adrian

[1] http://lkml.org/lkml/2007/3/13/276
[2] http://lkml.org/lkml/2007/3/7/540

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

