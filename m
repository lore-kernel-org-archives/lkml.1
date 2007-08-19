Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbXHSXCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbXHSXCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 19:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbXHSXCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 19:02:17 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60070 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752286AbXHSXCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 19:02:17 -0400
Date: Mon, 20 Aug 2007 01:01:36 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [2.6 patch] update .gitignore
Message-ID: <20070819230136.GE32595@stusta.de>
References: <20070801131051.GO3972@stusta.de> <20070801190753.GB5763@martell.zuzino.mipt.ru> <20070801191037.GR3972@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070801191037.GR3972@stusta.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 09:10:37PM +0200, Adrian Bunk wrote:
> On Wed, Aug 01, 2007 at 11:07:53PM +0400, Alexey Dobriyan wrote:
> > On Wed, Aug 01, 2007 at 03:10:51PM +0200, Adrian Bunk wrote:
> > > --- linux-2.6.23-rc1-mm2/.gitignore.old
> > > +++ linux-2.6.23-rc1-mm2/.gitignore
> > > @@ -14,18 +14,25 @@
> > >  *.so
> > >  *.mod.c
> > >  *.i
> > > +!include/asm-*/*.i
> > 
> > I think these should be renamed to .S and let .i alone for preprocessed
> > stuff.
> >...
> 
> Fine with me if Andi agrees.

Andi?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

