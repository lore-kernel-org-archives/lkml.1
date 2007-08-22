Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbXHVIGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbXHVIGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbXHVIGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:06:39 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42552 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbXHVIGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:06:38 -0400
Date: Wed, 22 Aug 2007 10:07:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Andres Salomon <dilinger@queued.net>, akpm@linux-foundation.org,
       kbuild-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kbuild-devel] [PATCH] kconfig: add *_silentdefconfig feature for config targets
Message-ID: <20070822080757.GB19521@uranus.ravnborg.org>
References: <20070820204020.7cde776e.dilinger@queued.net> <Pine.LNX.4.64.0708211717180.1817@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708211717180.1817@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> >   - We seem to switch between using _() and not using it for strings; I'm
> >     assuming that we don't actually care about i18n in conf.c, and that the
> >     _() stuff was just copied from elsewhere.  If that's not the case, I
> >     can update the patch to wrap strings properly.
> 
> I try to keep this uptodate, but I don't really check for this.

It is on my TODO list to go through the missing bits based on a patch
from the linux kernel translation project.
But work-work keeps me outright busy atm.
So not much itime for kernel-work :-(

	Sam
