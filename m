Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbYAEFtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbYAEFtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 00:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYAEFtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 00:49:10 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36844 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbYAEFtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 00:49:09 -0500
Date: Sat, 5 Jan 2008 07:48:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild update
Message-ID: <20080105054840.GB9976@does.not.exist>
References: <20080103213255.GA21811@uranus.ravnborg.org> <20080104132316.GA2485@hacking> <20080104143953.GA30536@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080104143953.GA30536@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 03:39:53PM +0100, Sam Ravnborg wrote:
> On Fri, Jan 04, 2008 at 09:23:16PM +0800, WANG Cong wrote:
> > 
> > {snip}
> > 
> > >TODO items (from my mailbox - I have plenty more)
> > >=================================================
>...
> > >- i18n patch for mconf and friends (from Kernel Translator project)
> > >  is old but several bits of it needs to be applied to better support i18n
> > 
> > Hmm, I glanced at that project. It's old and seems freezed now.
> > I don't know if people still have interests in the i18n of kconfig.
> > If so, I think I can help with the Chinese part. ;)
> 
> >From the off-list communication I have had there is indeed an interest.
> It sort of stopped at one point due to missing integration in mainline.
> What I refer to is mostly the mconf.c bits, but I would also like to
> see what lkml says to a sample of .po files included in the kernel
> for a number of languages.
> 
> One criteria to get a .po file integrated could be at least 10% of the
> strings translated or similar.

Besides the initial translation efforts a big problem would be to 
also find people who will regularly update the translations for
many years.

Otherwise the next round of spelling fixes will push this far
below 10%...

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

