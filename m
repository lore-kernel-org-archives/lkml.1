Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbXECGNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbXECGNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbXECGNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:13:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59822 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbXECGNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:13:49 -0400
Date: Wed, 2 May 2007 22:37:31 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Hans-J?rgen Koch <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, torvalds@osdl.org, tglx@linutronix.de
Subject: Re: [PATCH 2/3] UIO: Documentation
Message-ID: <20070503053731.GA17864@kroah.com>
References: <20070427224957.GA17967@kroah.com> <200705021041.35422.hjk@linutronix.de> <20070502135237.59a46232.randy.dunlap@oracle.com> <200705030000.29272.hjk@linutronix.de> <20070502163734.070d5047.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502163734.070d5047.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 04:37:34PM -0700, Randy Dunlap wrote:
> On Thu, 3 May 2007 00:00:28 +0200 Hans-J?rgen Koch wrote:
> 
> > Am Mittwoch 02 Mai 2007 schrieb Randy Dunlap:
> > > On Wed, 2 May 2007 10:41:35 +0200 Hans-J?rgen Koch wrote:
> > > > Am Mittwoch 02 Mai 2007 01:42 schrieb Randy Dunlap:
> > > > > > +<title>The Userspace I/O HOWTO</title>
> > > > >
> > > > > Most of this reads well.  Thanks.
> > > > > A few typo corrections are below...
> > > >
> > > > Thank you for your work. I generated a new patch that includes all your
> > > > suggestions and also fixes the build problems.
> 
> OK, your fixes all look good, but still needs one minor fix (below).
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Hm, I have about 3 different patches here now, all dependant on each
other, yet I can't tell which goes first :(

Can someone just send me 1, or 3 with the correct order in which to
apply them?

thanks,

greg k-h
