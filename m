Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbXEINDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbXEINDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbXEINDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:03:47 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42960 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755625AbXEINDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:03:46 -0400
Date: Wed, 9 May 2007 15:03:47 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-pcmcia@lists.infradead.org
Subject: Re: pcmcia ioctl removal
Message-ID: <20070509130346.GC23574@stusta.de>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <20070501084623.GB14364@infradead.org> <20070509125415.GA4720@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070509125415.GA4720@ucw.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 12:54:16PM +0000, Pavel Machek wrote:
> Hi!
> 
> > >  pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
> > 
> > ...
> > 
> > > Dominik is busy.  Will probably re-review and send these direct to Linus.
> > 
> > The patch above is the removal of cardmgr support.  While I'd love to
> > see this cruft gone it definitively needs maintainer judgement on whether
> > they time has come that no one relies on cardmgr anymore.
> 
> I remember needing cardmgr few months ago on sa-1100 arm system. I'm
> not sure this is obsolete-enough to kill.

Why didn't pcmciautils work?

> 							Pavel

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

