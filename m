Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbYAFPIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbYAFPIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 10:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYAFPIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 10:08:17 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56225 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbYAFPIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 10:08:16 -0500
Date: Sun, 6 Jan 2008 17:07:44 +0200
From: Adrian Bunk <bunk@kernel.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild update
Message-ID: <20080106150744.GJ2082@does.not.exist>
References: <20080103213255.GA21811@uranus.ravnborg.org> <20080104132316.GA2485@hacking> <20080104143953.GA30536@uranus.ravnborg.org> <20080105054840.GB9976@does.not.exist> <20080106142606.GB2528@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080106142606.GB2528@hacking>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 10:26:06PM +0800, WANG Cong wrote:
> 
> >> It sort of stopped at one point due to missing integration in mainline.
> >> What I refer to is mostly the mconf.c bits, but I would also like to
> >> see what lkml says to a sample of .po files included in the kernel
> >> for a number of languages.
> >> 
> >> One criteria to get a .po file integrated could be at least 10% of the
> >> strings translated or similar.
> 
> Well, I think it's worthy. The translation effort will be valuable
> and much helpful for non-English-speaking peoples.
> 
> >Besides the initial translation efforts a big problem would be to 
> >also find people who will regularly update the translations for
> >many years.
> 
> Yes, that's really a problem. But I think the updates won't be
> too frequent, only update for stable release is enough.

"only" is the wrong word in this context.

If someone would update the translations for one language every
3 months for the next years that would be great and disprove my 
concerns.

After all, updates every 3 months would beat the maintainance level of 
at least three of our architectures...

And don't underestimate the amount of work required - even when talking 
about requiring "only" 10% of the help texts translated that's a four 
digit number of lines to translate.

> If we can make this to be an offical project for Linux kernel, I
> think it won't be a big problem.

We don't even manage to maintain the English language texts properly,
and I am therefore not overly optimistic that we'll have the 
translations maintained properly for many years.

OTOH, if someone wouldn't just blindly translate the outdated English 
texts but also review the English texts when translating this alone 
might be worth it...

> Regards.
> 
>  Cong

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

