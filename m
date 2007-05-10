Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbXEJIS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbXEJIS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbXEJISp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:18:45 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43793 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755675AbXEJISo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:18:44 -0400
Date: Thu, 10 May 2007 10:18:45 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: John Anthony Kazos Jr <jakj@j-a-k-j.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: include files: convert "include" subdirectory to UTF-8
Message-ID: <20070510081845.GJ23574@stusta.de>
References: <200705092102.l49L2axT029607@hera.kernel.org> <Pine.LNX.4.64.0705100921230.13222@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0705100921230.13222@anakin>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 09:22:44AM +0200, Geert Uytterhoeven wrote:
> On Wed, 9 May 2007, Linux Kernel Mailing List wrote:
> > diff --git a/include/asm-m68k/atarihw.h b/include/asm-m68k/atarihw.h
> > index f28acd0..6211363 100644
> > --- a/include/asm-m68k/atarihw.h
> > +++ b/include/asm-m68k/atarihw.h
> > @@ -2,7 +2,7 @@
> >  ** linux/atarihw.h -- This header defines some macros and pointers for
> >  **                    the various Atari custom hardware registers.
> >  **
> > -** Copyright 1994 by Bj?rn Brauel
> > +** Copyright 1994 by Bjrn Brauel
> >  **
> >  ** 5/1/94 Roman Hodek:
> >  **   Added definitions for TT specific chips.
> > diff --git a/include/asm-m68k/atariints.h b/include/asm-m68k/atariints.h
> > index 0ed454f..ce6c445 100644
> > --- a/include/asm-m68k/atariints.h
> > +++ b/include/asm-m68k/atariints.h
> > @@ -1,7 +1,7 @@
> >  /*
> >  ** atariints.h -- Atari Linux interrupt handling structs and prototypes
> >  **
> > -** Copyright 1994 by Bj?rn Brauel
> > +** Copyright 1994 by Bjrn Brauel
> >  **
> >  ** 5/2/94 Roman Hodek:
> >  **   TT interrupt definitions added.
> 
> These two seem to have failed.

They changed from wrong and invalid UTF-8 to wrong and valid UTF-8.

I saw this when applying the patch, but I wasn't sure which character 
would be correct in this name.

> Gr{oetje,eeting}s,
> 
> 						Geert

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

