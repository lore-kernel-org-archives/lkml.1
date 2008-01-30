Return-Path: <linux-kernel-owner+w=401wt.eu-S1759019AbYA3RyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbYA3RyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbYA3RyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:54:04 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42631 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbYA3RyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:54:03 -0500
Date: Wed, 30 Jan 2008 19:54:35 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>, rms@gnu.org
Subject: Re: ndiswrapper and GPL-only symbols redux
Message-ID: <20080130175435.GA29368@does.not.exist>
References: <1201641765.18773.35.camel@dv> <20080129225701.GS8767@does.not.exist> <1201650267.18773.118.camel@dv> <20080130002514.GA1802@does.not.exist> <1201658555.24898.27.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1201658555.24898.27.camel@dv>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 09:02:35PM -0500, Pavel Roskin wrote:
> On Wed, 2008-01-30 at 02:25 +0200, Adrian Bunk wrote:
> 
> > > > It is interesting that someone posting with an @gnu.org address claims
> > > > that dynamic linking of not GPLv2 compatible code into GPLv2 code was
> > > > not a copyright violation.
> > > 
> > > No, I'm representing myself only.  I don't think you represent all
> > > kernel developers when posting from the kernel.org address.
> > 
> > I'm not using my @kernel.org address except for kernel issues and I'm 
> > not using a company address in linux-kernel discussions.
> > 
> > Mailing lists of a project or a company are something completely 
> > different from using a project or company address outside of the 
> > project.
> 
> OK, I'll think about it.
> 
> > > I, for one, would welcome an informed position of the FSF.  It may have
> > > interesting implications for Wine, ReactOS, mplayer, qemu, Java and many
> > > other programs loading non-free compiled code at the run time.
> > 
> > Wine is licenced under the terms of the LGPL.
> > 
> > ReactOS is licenced under the terms of the GPL with a licence 
> > exception for runtime linking of non-free modules.
> > 
> > QEMU is licenced under the terms of the GPL with a licence exception for 
> > runtime linking with libqemu.a.
> > 
> > GNU classpath (and libgcj) are licenced under the terms of the GPL with 
> > a licence exception for runtime linking with it.
> > 
> > As you can see, all of the above explicitely address this issue.
> > 
> > The only program from your list that has a fishy licencing is mplayer.
> 
> Thanks for the detailed analysis!
> 
> Anyway, as far as I know, copyright covers copying of works,

The GPL might only talk about distribution.

But copyright law is not restricted to copying of work.

IANAL, and I don't know abou the laws in other countries, but at least 
in Germany modifications of a copyrighted work require the permission of 
the copyright holder.

It's e.g. a not so uncommon problem that someone wants to modify a 30 or 
80 years old building, and since the original contract with the 
architect did not grant the owner of the building the rights to modify 
it he needs to ask the architect (or the architect's heirs) who has the 
(nontransferable) copyright on the building for the permission to modify 
the building. [1]

> and dynamic
> linking never creates anything suitable for copying.  The "derived work"
> stays in memory, just like it does when a proprietary program runs on
> top of the Linux kernel.  Memory dumps might be illegal to distribute
> though.

Look at what Geert quoted in this thread as opinion of actual lawyers.

> I'm not a lawyer and the above is not a legal advice.  I don't represent
> Free Software Foundation.
> 
> Regards,
> Pavel Roskin

cu
Adrian

[1] The building must be above the threshold of originality for giving 
    the architect a copyright and there are other laws that might  
    force the copyright holder to allow some modifications.

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

