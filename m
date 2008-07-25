Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbYGYJlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbYGYJlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbYGYJlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:41:39 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:60855 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbYGYJli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:41:38 -0400
Date: Fri, 25 Jul 2008 11:41:31 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Altobelli <david.altobelli@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Let HP iLO driver depend on PCI
Message-ID: <20080725094131.GA4436@osiris.boeblingen.de.ibm.com>
References: <20080725022048.GB5179@osiris.boeblingen.de.ibm.com> <20080724215652.24e4e550.akpm@linux-foundation.org> <20080725153502.283aae1f.sfr@canb.auug.org.au> <20080724231519.b4553fa1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724231519.b4553fa1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 11:15:19PM -0700, Andrew Morton wrote:
> On Fri, 25 Jul 2008 15:35:02 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Andrew,
> > 
> > On Thu, 24 Jul 2008 21:56:52 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > Three weeks and nobody did an allmodconfig build on linux-next for s390
> > > or m68k (at least).
> > 
> > http://kisskb.ellerman.id.au/kisskb/branch/9/
> > 
> 
> Wow, lots of red.
> 
> May I revise my comment?  Three weeks and nobody did anything about the
> failing allmodconfig builds on linux-next and s390 (at least).

Not true. I sent patches for all (s390) build failures two weeks ago.
Nobody cared. Patch for this specific build failure is available
here http://marc.info/?l=linux-next&m=121577361309086&w=2 .

> Is anyone actively monitoring that page and doing the requisite culprit-poking?

Where to send patches to? And who takes care they get integrated before
the merge window opens?
