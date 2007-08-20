Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbXHTSBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbXHTSBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 14:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbXHTSBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 14:01:25 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44593 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbXHTSBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 14:01:24 -0400
Date: Mon, 20 Aug 2007 14:01:09 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Nicolas Pitre <nico@cam.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Jon Smirl <jonsmirl@gmail.com>,
       Git Mailing List <git@vger.kernel.org>
Subject: Re: Git tree for old kernels
Message-ID: <20070820180109.GE18377@filer.fsl.cs.sunysb.edu>
References: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com> <alpine.LFD.0.999.0708191453030.16727@xanadu.home> <20070820171618.GB9869@filer.fsl.cs.sunysb.edu> <alpine.LFD.0.999.0708201334000.16727@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708201334000.16727@xanadu.home>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 01:40:52PM -0400, Nicolas Pitre wrote:
> On Mon, 20 Aug 2007, Josef Sipek wrote:
> 
> > On Sun, Aug 19, 2007 at 03:24:56PM -0400, Nicolas Pitre wrote:
> > > On Sun, 22 Jul 2007, Jon Smirl wrote:
> > > 
> > > > Continuing on with kernel archeology for embedded systems, any
> > > > interest in making a git tree with all of the kernel versions from the
> > > > beginning up to the start of the current git tree?
> > > 
> > > I just put the archive I've gathered so far in a Git tree on kernel.org:
> > > 
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/nico/archive.git
> > > 
> > > It is also available through gitweb from:
> > > 
> > >     http://git.kernel.org/?p=linux/kernel/git/nico/archive.git
> >  
> > I don't mean to nit-pick but, would it be possible to have the timestamps
> > for the commits closer to the release dates?
> 
> Well, the author timestamp already is, based on the date of the 
> announcement message used for the commit log, including the timezone.  
> If you find errors in those please tell me.

Ah ok. Too bad gitweb displays the commit times => throws off some of the
sorting too.

/me prods gitweb people

> The commit timestamp, however, is the time when _I_ created the 
> repository, hence it should not be that interesting.

Too bad that's the date you see all over the place :( 

Jeff.

-- 
NT is to UNIX what a doughnut is to a particle accelerator.
