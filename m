Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbXHTRlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbXHTRlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbXHTRlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:41:00 -0400
Received: from relais.videotron.ca ([24.201.245.36]:41445 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXHTRk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:40:59 -0400
Date: Mon, 20 Aug 2007 13:40:52 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: Re: Git tree for old kernels
In-reply-to: <20070820171618.GB9869@filer.fsl.cs.sunysb.edu>
X-X-Sender: nico@xanadu.home
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: lkml <linux-kernel@vger.kernel.org>, Jon Smirl <jonsmirl@gmail.com>,
       Git Mailing List <git@vger.kernel.org>
Message-id: <alpine.LFD.0.999.0708201334000.16727@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com>
 <alpine.LFD.0.999.0708191453030.16727@xanadu.home>
 <20070820171618.GB9869@filer.fsl.cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007, Josef Sipek wrote:

> On Sun, Aug 19, 2007 at 03:24:56PM -0400, Nicolas Pitre wrote:
> > On Sun, 22 Jul 2007, Jon Smirl wrote:
> > 
> > > Continuing on with kernel archeology for embedded systems, any
> > > interest in making a git tree with all of the kernel versions from the
> > > beginning up to the start of the current git tree?
> > 
> > I just put the archive I've gathered so far in a Git tree on kernel.org:
> > 
> >     git://git.kernel.org/pub/scm/linux/kernel/git/nico/archive.git
> > 
> > It is also available through gitweb from:
> > 
> >     http://git.kernel.org/?p=linux/kernel/git/nico/archive.git
>  
> I don't mean to nit-pick but, would it be possible to have the timestamps
> for the commits closer to the release dates?

Well, the author timestamp already is, based on the date of the 
announcement message used for the commit log, including the timezone.  
If you find errors in those please tell me.

The commit timestamp, however, is the time when _I_ created the 
repository, hence it should not be that interesting.

> I must say, impressive work.

Thanks!


Nicolas
