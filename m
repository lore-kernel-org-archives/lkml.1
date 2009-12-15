Return-Path: <linux-kernel-owner+w=401wt.eu-S1761708AbZLOXI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761708AbZLOXI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761459AbZLOXIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:08:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762131AbZLOXDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:03:03 -0500
Date: Tue, 15 Dec 2009 15:02:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Tony Lindgren <tony@atomide.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org
Subject: Re: linux-next: origin tree build failure
In-Reply-To: <20091216094541.e59d36fa.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.0912151501520.14385@localhost.localdomain>
References: <20091215164108.45c9d766.sfr@canb.auug.org.au> <20091215145344.GA30710@sirena.org.uk> <20091215172717.GF4575@atomide.com> <20091216094541.e59d36fa.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Dec 2009, Stephen Rothwell wrote:

> Hi Tony,
> 
> On Tue, 15 Dec 2009 09:27:17 -0800 Tony Lindgren <tony@atomide.com> wrote:
> >
> > * Mark Brown <broonie@opensource.wolfsonmicro.com> [091215 06:52]:
> > > On Tue, Dec 15, 2009 at 04:41:08PM +1100, Stephen Rothwell wrote:
> > > 
> > > > I have applied this patch for today (please check):
> > > 
> > > Looks good to me too, fwiw:
> > > 
> > > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > 
> > Good thing we have for-next to catch things like this.
> 
> Except if the renaming patch had gone through linux-next (even for one
> day) we would have found the problem *before* it was in Linus' tree ...

I think maybe Tony was being ironic, exactly because of this.

		Linus
