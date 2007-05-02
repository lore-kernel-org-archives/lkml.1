Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbXEBUxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbXEBUxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbXEBUxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:53:49 -0400
Received: from THUNK.ORG ([69.25.196.29]:40749 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbXEBUxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:53:48 -0400
Date: Wed, 2 May 2007 16:53:38 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070502205338.GG19442@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>,
	"David R. Litwin" <presently42@gmail.com>,
	linux-kernel@vger.kernel.org
References: <op.tqqwdfzcftfxs2@localhost.localdomain> <Pine.BSO.4.63.0705021658100.11088@rudy.mif.pg.gda.pl> <20070502164247.0e98f77c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502164247.0e98f77c@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 04:42:47PM +0100, Alan Cox wrote:
> > I'm just found something new in filtered folder by "ZFS" word in RSS feed 
> > from blogs.sun.com and on firs look it may be some continuation of this 
> > thread:
> > 
> > http://blogs.sun.com/darren/entry/zfs_under_gplv2_already_exists
> > 
> > I'm not check completly this .. so don't beat me if it is not true :)
> 
> Useful if accurate as the GPLv2 and Sun origin means youa re clear for
> any patents Sun used in that code but maybe not for any in the pure CDDL
> bits. Definitely positive.

Well, except remember that they only made sources available so that
GRUB could boot OpenSolaris.  Grub only requires read-only access to
the filesystem, and what was made available under GPLv2 was only a
distinct subset of the full ZFS sources.

						- Ted

