Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbXFTWTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbXFTWTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXFTWTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:19:17 -0400
Received: from canuck.infradead.org ([209.217.80.40]:46587 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbXFTWTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:19:16 -0400
Date: Wed, 20 Jun 2007 15:18:09 -0700
From: Greg KH <greg@kroah.com>
To: Malte Cornils <malte@cornils.net>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rodrigo Luiz <troops.of.doom@gmail.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>, Ben Collins <bcollins@ubuntu.com>,
       reiserfs-devel@vger.kernel.org, "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [1/2] 2.6.22-rc5: known regressions
Message-ID: <20070620221809.GA12958@kroah.com>
References: <467543E1.1060001@googlemail.com> <20070618162915.GA7440@kroah.com> <200706190126.23091.malte@cornils.net> <200706202350.00235.malte@cornils.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706202350.00235.malte@cornils.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 11:49:59PM +0200, Malte Cornils wrote:
> Am Dienstag, 19. Juni 2007 01:26 schrieb Malte Cornils:
> > Hello,
> > Am Montag, 18. Juni 2007 18:29 schrieb Greg KH:
> > > > > Subject    : PCI setup hangs on Asus Notebook (nolapic helps)
> > > > > References : http://lkml.org/lkml/2007/6/14/161
> > > > > Submitter  : Malte Cornils <malte@cornils.net>
> > > > > Status     : unknown [...]
> > >
> > > Can you use 'git bisect' to track down the patch that causes this to
> > > fail?
> >
> > I will do this, however, it will likely take me a day or two to find. I'll
> > report back then.
> 
> Well, more likely a few more days due to difficult physical access to the 
> laptop at the moment; however, it's *not* a regression introduced in 
> 2.6.22rc, it was introduced at some point of time between 2.6.18 and 
> 2.6.19-rc1.

Great, thanks for letting us know about this.

greg k-h
