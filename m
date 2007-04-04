Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbXDDRsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbXDDRsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXDDRsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:48:40 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42874 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752226AbXDDRsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:48:39 -0400
Date: Wed, 4 Apr 2007 19:48:39 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Rene Herman <rene.herman@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
Message-ID: <20070404174839.GQ27660@stusta.de>
References: <46138B4C.2050409@gmail.com> <20070404123311.GA18552@infradead.org> <1175698135.5815.447.camel@violet> <20070404150231.GE27660@stusta.de> <4613C963.6070409@gmail.com> <20070404170016.453d26f1@the-village.bc.nu> <4613D492.2070404@gmail.com> <s5hps6kxefx.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <s5hps6kxefx.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 07:00:18PM +0200, Takashi Iwai wrote:
> At Wed, 04 Apr 2007 18:38:42 +0200,
> Rene Herman wrote:
> > 
> > Other cases-in-point; I've lately been rummaging through sound/isa a 
> > bit. Nothing much copyrightable again but especially in those situations 
> > where (some of the) original authors are no longer active, I do again 
> > want people to contact me about them if needed. And all the "which one 
> > of the three people listed here is maintaining this" is yet another.
> 
> Practically, the information can go through subsystem maintainers to
> specific person (you) in such a case, as the tree is still more or
> less maintained by subsystem maintainers.
> 
> But in general, it would be nice to have an easy way to find a
> maintainer (not author) from a module binary, and I agree
> MODULE_MAINTAINER can work well for such a purpose.  It's no mandatory
> field, but could be some help.

Yes, it would be nice.

But would this information always be kept up-to-date for the whole tree?
I don't see this happen.

> Takashi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

