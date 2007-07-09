Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbXGIRSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbXGIRSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbXGIRSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:18:36 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41405 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbXGIRSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:18:34 -0400
To: Rob Landley <rob@landley.net>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
Reply-To: Gerrit Huizenga <gh@us.ibm.com>
From: Gerrit Huizenga <gh@us.ibm.com>
Subject: Re: Documentation of kernel messages (Summary) 
In-reply-to: Your message of Mon, 09 Jul 2007 12:48:24 EDT.
             <200707091248.24994.rob@landley.net> 
Date: Mon, 09 Jul 2007 10:18:57 -0700
Message-Id: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 09 Jul 2007 12:48:24 EDT, Rob Landley wrote:
> In regard to translating kernel messages:
> 
> On Monday 09 July 2007 01:36:31 H. Peter Anvin wrote:
> > Kunai, Takashi wrote:
> > > (1) Your kernel development proposal will be greatly supported by
> > > Japanese vendor community. At the same time, it needs support from the
> > > kernel communities, as well.
> >
> > There is a very strong reason for the kernel community to NOT support
> > this: it makes it much harder to deal with bug reports.
> 
> Agreed.

[...]

> 
> As for the documentation translations themselves, I note that Eric Raymond 
> dissuaded me from actually hosting translations of kernel documentation on 
> http://kernel.org/doc due to his experience with translations of his own 
> writings.  If he hosts the translations on his website, they never get 
> updated again.  But if he makes the contributor host them on their own 
> website, then they sometimes get updated.
> 
> For my part, I can't _tell_ when a given translation is out of date because I 
> can't read it, and I certainly can't update it.  So I agree with Eric and I'm 
> linking to sites hosting kernel documentation in other languages rather than 
> hosting them myself.  I've got a good link to a Japanese site, need to ping 
> the contributors of the chinese documentation and see if they have a site for 
> it...

Yeah, but it seems like having a translations directory in the kernel
avoids that problem - anyone can update, it is a single source, no digging
for sites that aren't tied to the kernel, available in the distros
directly, etc.

I'm not sure that the web site hosting argument is a good one.  Arch
maintainers and Language Maintainers have some similarities.  Also, being
able to clearly mark which version of a document was last translated
would help a bit with the fact that most of us aren't proficient in all
of the world's languages.  But, knowing who the translation maintainer is,
and when the translation was last updated allows both the original doc
maintainer and the translation document maintainer to see when a document
likely needs to be updated.  And that is probably good enough.

gerrit
