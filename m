Return-Path: <linux-kernel-owner+w=401wt.eu-S1946535AbXBIPb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946535AbXBIPb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946536AbXBIPb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:31:27 -0500
Received: from gate.perex.cz ([212.20.107.50]:37454 "EHLO gate.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946535AbXBIPb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:31:27 -0500
Date: Fri, 9 Feb 2007 16:30:29 +0100 (CET)
From: Jaroslav Kysela <perex@suse.cz>
X-X-Sender: perex@tm8103-a.perex-int.cz
To: Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [ALSA PATCH] alsa-git merge request
In-Reply-To: <s5hd54jnzoj.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.61.0702091630010.5511@tm8103-a.perex-int.cz>
References: <Pine.LNX.4.61.0702091451010.5511@tm8103-a.perex-int.cz>
 <s5hk5yro1rr.wl%tiwai@suse.de> <Pine.LNX.4.61.0702091538270.5511@tm8103-a.perex-int.cz>
 <s5hejozo0al.wl%tiwai@suse.de> <s5hd54jnzoj.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007, Takashi Iwai wrote:

> At Fri, 09 Feb 2007 15:47:30 +0100,
> I wrote:
> > 
> > At Fri, 9 Feb 2007 15:40:21 +0100 (CET),
> > Jaroslav Kysela wrote:
> > > 
> > > On Fri, 9 Feb 2007, Takashi Iwai wrote:
> > > 
> > > > At Fri, 9 Feb 2007 15:02:05 +0100 (CET),
> > > > Jaroslav Kysela wrote:
> > > > > 
> > > > > Linus, please do an update from:
> > > > > 
> > > > >   http://www.kernel.org/pub/scm/linux/kernel/git/perex/alsa.git
> > > > >   (linus branch)
> > > > 
> > > > Jaroslav, as I wrote you many times, this tree includes the wrong
> > > > patches!  If it's merged, we'd need fix patches in addition
> > > > eventually...
> > > 
> > > I replaced patches with your code a few days ago. If something else is 
> > > broken, please, let me know.
> > 
> > Strange, my local tree freshly pulled have old files.
> > I'll try to pull cleanly and check again.
> 
> Reconfirmed that it's still broken.  The below is a patch to fix.
> Please apply.

The bug-fix patch has been applied to alsa.git tree.

					Thanks,
						Jaroslav

-----
Jaroslav Kysela <perex@suse.cz>
Linux Kernel Sound Maintainer
ALSA Project, SUSE Labs
