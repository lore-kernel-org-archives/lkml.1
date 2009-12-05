Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZLELHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZLELHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 06:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZLELHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 06:07:18 -0500
Received: from isilmar.linta.de ([213.133.102.198]:47268 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753871AbZLELHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 06:07:17 -0500
Date: Sat, 5 Dec 2009 12:07:21 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Dmitry Artamonow <mad_soft@inbox.ru>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the pcmcia tree with the arm tree
Message-ID: <20091205110721.GB23213@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Russell King <rmk+lkml@arm.linux.org.uk>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Dmitry Artamonow <mad_soft@inbox.ru>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20091201140310.46dbdc59.sfr@canb.auug.org.au> <20091202115649.GA2150@rainbow> <20091203092525.17d939b3.sfr@canb.auug.org.au> <20091205103038.GA11140@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091205103038.GA11140@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 05, 2009 at 10:30:38AM +0000, Russell King wrote:
> On Thu, Dec 03, 2009 at 09:25:25AM +1100, Stephen Rothwell wrote:
> > Hi Dmitry,
> > 
> > On Wed, 2 Dec 2009 14:56:49 +0300 Dmitry Artamonow <mad_soft@inbox.ru> wrote:
> > >
> > > Fix looks good to me, and testing next-20091201 on real device (h3600)
> > > shows no problems with pcmcia.
> > 
> > Thanks for the confirmation.
> 
> Since Dominik has been ignoring this issue, and has already asked Linus to
> pull his tree with my (unfortunately just discovered buggy) changes in, I'm
> going to drop the H3600 PCMCIA changes until something can be sorted out.

Well, I hope that Linus merges the first bunch of PCMCIA changes soon, so
that we have a clean base to work from and to sort the dependecies in
ARM-related patches out.

Best,
	Dominik
