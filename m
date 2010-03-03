Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab0CCGsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:48:10 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53301 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754165Ab0CCGsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:48:08 -0500
Date: Wed, 3 Mar 2010 07:48:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] staging/dream: add missing include files/fix
	compilation
Message-ID: <20100303064806.GC25144@atrey.karlin.mff.cuni.cz>
References: <20100131092829.GJ2238@elf.ucw.cz> <1264953492.2059.5.camel@m0nster> <20100225193027.GA7391@elf.ucw.cz> <1267126586.5439.56.camel@c-dwalke-linux.qualcomm.com> <20100225194125.GA7645@elf.ucw.cz> <1267127298.5439.62.camel@c-dwalke-linux.qualcomm.com> <20100226213107.GA29615@elf.ucw.cz> <1267469856.29769.9.camel@c-dwalke-linux.qualcomm.com> <20100301211057.GA3004@elf.ucw.cz> <1267478118.29769.16.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267478118.29769.16.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > git checkout refs/remotes/origin/working-mmc
> > 
> > only to get (git log): [I think I was there before].
> > 
> > commit 2b0bcf161e83fc7d45476f3330f06b656a1f03d4
> > Author: Daniel Walker <dwalker@codeaurora.org>
> > Date:   Mon Feb 22 12:29:17 2010 -0800
> > 
> >     DMA fixes (get MMC working).
> > 
> > commit 5fc33446739aa7a0826d98a00cc50a712c6d60eb
> > Author: San Mehat <san@google.com>
> > Date:   Wed Feb 3 12:59:29 2010 -0800
> > 
> >     drivers: mmc: msm_sdcc: Add EMBEDDED_SDIO support
> >     
> >     Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
> 
> I actually dropped a patch between the two above, otherwise the history
> is very similar. I think you have the right one, are you still getting
> the compile errors?

No, now it compiles and detects MMC, which is very very good. Now
framebuffer needs to be sorted and we'll have usable machine :-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
