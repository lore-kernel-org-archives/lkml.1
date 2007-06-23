Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbXFWUyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbXFWUyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 16:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXFWUyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 16:54:07 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37488 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388AbXFWUyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 16:54:06 -0400
Date: Sat, 23 Jun 2007 22:54:26 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3]
	doc/oops-tracing: add Code: decode info
Message-ID: <20070623205426.GQ23017@stusta.de>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706221626.39969.ak@suse.de> <20070622094429.0910c7cb.randy.dunlap@oracle.com> <200706221923.02736.ak@suse.de> <20070622132810.3c758590.randy.dunlap@oracle.com> <E1I2159-0005AH-DS@flower> <20070623104303.a186c5a8.randy.dunlap@oracle.com> <20070623105645.ad4dbace.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070623105645.ad4dbace.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 10:56:45AM -0700, Andrew Morton wrote:
> On Sat, 23 Jun 2007 10:43:03 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > > NAK.
> > 
> > Sorry I slept thru another wonderful festival on LKML.
> 
> That's probably the best strategy.
> 
> > You don't have the authority to NAK the patch.
> 
> Yeah.  nak to naks.
> 
> > OTOH, you also didn't supply a patch.  If you do this, I'll be
> > glad to consider it.  If I can read it, that is.
> 
> Yes, I plan on merging that patch as-is.  If it was a compulsory part of
> kbuild then that would be a problem but as some optional tool I don't think
> that a bashism matters much.  Someone can fix it sometime should they feel
> so motivated.

Oleg didn't express it very polite, but he has a valid point that bash 
scripts should start with "#!/bin/bash" since /bin/sh might be some 
shell other than bash.

Randy, am I right to assume that such a change to your patch would be OK?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

