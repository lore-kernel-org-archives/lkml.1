Return-Path: <linux-kernel-owner+w=401wt.eu-S1761778AbYFFHQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761778AbYFFHQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 03:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYFFHQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 03:16:49 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:34584 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbYFFHQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 03:16:48 -0400
Date: Fri, 6 Jun 2008 09:16:46 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: ralf@linux-mips.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] Alchemy: export get_au1x00_speed for modules
Message-ID: <20080606071646.GA16498@roarinelk.homelinux.net>
References: <20080519080339.GA21985@roarinelk.homelinux.net> <20080519080416.GB21985@roarinelk.homelinux.net> <483149E0.6010009@ru.mvista.com> <20080519094953.GA22445@roarinelk.homelinux.net> <20080605230311.7f98cd1a@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605230311.7f98cd1a@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

On Thu, Jun 05, 2008 at 11:03:11PM +0200, Pierre Ossman wrote:
> On Mon, 19 May 2008 11:49:53 +0200
> Manuel Lauss <mano@roarinelk.homelinux.net> wrote:
> 
> > Hi Sergei,
> > 
> > >> From 8492076e98c7fd47c9dee53984dbd9568ace357d Mon Sep 17 00:00:00 2001
> > >> From: Manuel Lauss <mlau@msc-ge.com>
> > >> Date: Wed, 7 May 2008 13:42:55 +0200
> > >> Subject: [PATCH] Alchemy: export get_au1x00_speed for modules
> > >>
> > >> au1xmmc.c driver depends on it, so export it for modules.
> > >>
> > >> Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
> > >>   
> > >
> > >   I thought that has been merged.
> > 
> > Yes, Ralf merged it into linux-mips repo, but it is not yet in
> > mainline and the rest of the patches are against linus' git.
> > 
> 
> So who should push this to Linus? If this set is the only patches
> depending on it, it would be easiest if I carry it in my tree.

I'd prefer if you (Pierre) carried them all since they all depend on
each other (kind of, anyway).  And it seems Ralf has gone silent anyway :)

Thank you!
	Manuel Lauss

