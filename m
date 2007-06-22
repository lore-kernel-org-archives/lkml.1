Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbXFVSyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbXFVSyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbXFVSyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:54:04 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:54758
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943AbXFVSyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:54:03 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
Date: Fri, 22 Jun 2007 14:53:59 -0400
User-Agent: KMail/1.9.6
Cc: "dave young" <hidave.darkstar@gmail.com>, "Li Yang" <leoli@freescale.com>,
       gregkh@suse.de, linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       bryan.wu@analog.com, "TripleX Chung" <xxx.phy@gmail.com>,
       "Maggie Chen" <chenqi@beyondsoft.com>, torvalds@linux-foundation.org
References: <1182436817579-git-send-email-leoli@freescale.com> <200706220133.19496.rob@landley.net> <20070622102123.49182855@the-village.bc.nu>
In-Reply-To: <20070622102123.49182855@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706221454.03926.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007 05:21:23 Alan Cox wrote:
> > The question is, do the kernel developers want to encourage people who
> > don't speak English to mess with the kernel, any more than they want to
> > encourage kernel developers who don't know C?  Is kernel documentation in
> > Chinese a
>
> The majority of the world population do not speak English. There are
> existing contributors do not speak English (and I'm not being funny about
> the USSA here) - you don't notice because they have a team member who
> speaks passable English.

Ok.  Cool.  If this is not a problem, that's good to know.

> There are also entire non-English sites around things like Linux that
> monoglot English speakers generally don't notice exist.

I'm aware of this.

> > P.S.  The hardest part of putting together a kernel documentation web
> > page is actually indexing it coherently.  It's not very useful to just
> > dump together
>
> For the kernel I would follow the kernel tree so that its always
>
> 	/[languagecode]/Documentation/...

That PS was about putting up a kernel doc web page, not about the existing 
kernel Documentation tree.

The existing Documentation tree has, at the top level, coding style 
guidelines, files documenting the kernel community, a file documenting the 
Amiga "zorro" bus, a half-dozen files about old multiport serial cards, 
documentation about several different types of locking, a penguin graphic 
from 1996, your documentation on the tty layer, a document on how to 
configure BINFMT_MISC to autorun .NET files with mono, and zillions of other 
random unrelated topics that are sorted based on where random passerby put 
things down last.

I sent a couple patches to shuffle stuff around in there but it got lost on 
the noise.  More to the point, an HTML index can hotlink but text files have 
a harder time doing that, so if I'm making an HTML index it's probably best 
to link to the text files but not attempt to navigate with them.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
