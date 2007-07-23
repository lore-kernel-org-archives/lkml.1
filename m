Return-Path: <linux-kernel-owner+w=401wt.eu-S932532AbXGWAIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbXGWAIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761148AbXGWAIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:08:09 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41487 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759818AbXGWAII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:08:08 -0400
Date: Mon, 23 Jul 2007 02:07:32 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Roland McGrath <roland@redhat.com>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: Linus 2.6.23-rc1
Message-ID: <20070723000732.GP26212@stusta.de>
References: <200707230033.01357.alistair@devzero.co.uk> <20070722235130.D9B094D0489@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070722235130.D9B094D0489@magilla.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 04:51:30PM -0700, Roland McGrath wrote:
> > I'm fairly sure this is already known about on SPARC64 (see David Miller's 
> > email ""build-id" changes break sparc64"), but I just thought I'd let people 
> > know the warnings are also visible on x86_64:
> > 
> > "ld: warning: Cannot create .note.gnu.build-id section, --build-id ignored."
> 
> I don't have any such problem using an ld built from current binutils cvs.
> 
> > GNU assembler (GNU Binutils for Debian) 2.17.50.20070718
> 
> This ld build, whatever it is, is suspect.  
> I have no idea what code is in there.

That's the Debian unstable package of binutils containing what was on 
20070718 in the upstream binutils CVS (the version number comes from 
the upstream CVS).

> Thanks,
> Roland

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

