Return-Path: <linux-kernel-owner+w=401wt.eu-S1762673AbYD2VU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762673AbYD2VU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbYD2VUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:20:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57435 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYD2VUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:20:17 -0400
Date: Tue, 29 Apr 2008 22:14:11 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Adrian Bunk <bunk@kernel.org>, "Denis V. Lunev" <den@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: pcmcia_ioctl.c compile error
Message-ID: <20080429211410.GD31311@flint.arm.linux.org.uk>
Mail-Followup-To: Randy Dunlap <rdunlap@xenotime.net>,
	Adrian Bunk <bunk@kernel.org>, "Denis V. Lunev" <den@openvz.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-pcmcia@lists.infradead.org,
	Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
References: <20080429182709.GB2898@cs181133002.pp.htv.fi> <20080429201704.GA31311@flint.arm.linux.org.uk> <20080429135902.504b6362.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429135902.504b6362.rdunlap@xenotime.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 01:59:02PM -0700, Randy Dunlap wrote:
> On Tue, 29 Apr 2008 21:17:04 +0100 Russell King wrote:
> 
> > On Tue, Apr 29, 2008 at 09:27:10PM +0300, Adrian Bunk wrote:
> > > Commit 9c37066d888bf6e1b96ad12304971b3ddeabbad0 (proc: remove proc_bus) 
> > > came through -mm that contains a patch implementing the overdue removal 
> > > of the PCMCIA control ioctl that did not yet make it into Linus' tree:
> > 
> > Okay, this means at least one of my platforms is now dead as far as
> > building new kernels for it, and nothing I can do about that.  Ho hum.
> 
> I don't get it.  Several of us had building problems for a few
> days with some pasic driver.  We posted some bug reports and
> some patches, but we put up with it for a few days...

What don't you get?

I've said each time the PCMCIA ioctl removal topic came up that it would
give me this precise problem.  I've given details of _why_ it would cause
me that problem.  It's gone ahead inspite of that.

Concerning the pasic driver.  For fuck sake, why are you bringing that
up.  I made it *perfectly* and *crystal* clear that I *WAS* *NOT* in a
position to fix that thing - BECAUSE I WASN'T GOING TO BE IN FRONT OF A
COMPUTER FOR VERY LONG ON THOSE DAYS.  Which I knew would be the case on
Monday morning.  I _tried_ to stop the thing being merged, but Linus
merged it anyway, and then told me he'd done that _AFTER_ I'd gone to
bed on Monday.  I tried to ensure that I was in a position to cover
_all_ eventualities (except the one which actually occurred.)

So, between Monday midnight and Thursday morning, when do you expect me
to sort the resulting mess out, given that I was not even able to be
in front of a computer until about 10pm on Tuesday and Wednesday?

Oh, maybe you expect me to give up sleeping just for you?

What do you want me to do?  Quit because of it?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
