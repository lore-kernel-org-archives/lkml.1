Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbYKPQe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbYKPQe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYKPQeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:34:19 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:36950 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752421AbYKPQeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:34:18 -0500
Date: Sun, 16 Nov 2008 10:18:18 -0500
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@suse.cz>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Peter Alfredsen <loki_val@gentoo.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Lee Howard <lee.howard@mainpine.com>, linux-kernel@vger.kernel.org
Subject: Re: Is the PCI serial driver code GPL v2 or v3
Message-ID: <20081116151818.GD9987@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Pavel Machek <pavel@suse.cz>,
	Russell King <rmk+lkml@arm.linux.org.uk>,
	Peter Alfredsen <loki_val@gentoo.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Lee Howard <lee.howard@mainpine.com>, linux-kernel@vger.kernel.org
References: <20081106174341.GA8155@xolotl.n0ano.com> <200811061952.37490.loki_val@gentoo.org> <20081106191250.GA28514@flint.arm.linux.org.uk> <20081109193357.GA1549@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109193357.GA1549@ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 08:34:01PM +0100, Pavel Machek wrote:
> > It was based upon the original serial.c by Ted T'so, but with some
> > reworking to add a separate quirks table, and quite a number of cleanups.
> > 
> > My personal position is that code I author is GPLv2, and not GPLv2 or
> > later.  So it's a question whether you consider that I'm the author
> > of the code in that file, or whether you think it's Ted's with my
> > contributions were under Ted's original terms.
> 
> Original poster wants GPLv3 version for use in grub-2. Would you be
> willing to relicense your changes in serial_8250.c, so that he can do
> that? Would Ted be willing to do that?

I'd much rather have grub-2 relicense itself to GPLv2.  :-)

    	 	     	    	      	     	- Ted
