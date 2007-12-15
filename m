Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbXLODqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbXLODqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 22:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbXLODqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 22:46:09 -0500
Received: from ns2.suse.de ([195.135.220.15]:46751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbXLODqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 22:46:08 -0500
Date: Fri, 14 Dec 2007 19:49:10 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.10
Message-ID: <20071215034910.GB31056@suse.de>
References: <20071214194952.GA15765@kroah.com> <20071214185546.2cf66f2a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214185546.2cf66f2a.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 06:55:46PM -0800, Randy Dunlap wrote:
> On Fri, 14 Dec 2007 11:49:53 -0800 Greg Kroah-Hartman wrote:
> 
> > We (the -stable team) are announcing the release of the 2.6.23.10 kernel.
> > It a number of bugfixes and anyone using the 2.6.23 kernel series is
> > recommended to upgrade.
> > 
> > I'll also be replying to this message with a copy of the patch between
> > 2.6.23.9 and 2.6.23.10
> > 
> > The updated 2.6.23.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
> > and can be browsed at the normal kernel.org git web browser:
> >         http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary
> 
> 
> WARNING: vmlinux.o(.init.text.23+0x7e6b): Section mismatch: reference to .exit.text:br_fdb_fini (between 'br_init' and 'br_fdb_init')
> 
> Fixed by:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=73afc9069289bdb77cf0c81cb9775dcb63894bbe

Nice, thanks for letting me know, I'll add this to the next release.

greg k-h
