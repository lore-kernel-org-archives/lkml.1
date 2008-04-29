Return-Path: <linux-kernel-owner+w=401wt.eu-S1762673AbYD2VRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762673AbYD2VRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbYD2VRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:17:42 -0400
Received: from xenotime.net ([66.160.160.81]:35925 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751886AbYD2VRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:17:41 -0400
Date: Tue, 29 Apr 2008 14:17:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Adrian Bunk <bunk@kernel.org>, "Denis V. Lunev" <den@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: pcmcia_ioctl.c compile error
Message-Id: <20080429141736.dd483f2b.rdunlap@xenotime.net>
In-Reply-To: <20080429211410.GD31311@flint.arm.linux.org.uk>
References: <20080429182709.GB2898@cs181133002.pp.htv.fi>
	<20080429201704.GA31311@flint.arm.linux.org.uk>
	<20080429135902.504b6362.rdunlap@xenotime.net>
	<20080429211410.GD31311@flint.arm.linux.org.uk>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 22:14:11 +0100 Russell King wrote:

> On Tue, Apr 29, 2008 at 01:59:02PM -0700, Randy Dunlap wrote:
> > On Tue, 29 Apr 2008 21:17:04 +0100 Russell King wrote:
> > 
> > > On Tue, Apr 29, 2008 at 09:27:10PM +0300, Adrian Bunk wrote:
> > > > Commit 9c37066d888bf6e1b96ad12304971b3ddeabbad0 (proc: remove proc_bus) 
> > > > came through -mm that contains a patch implementing the overdue removal 
> > > > of the PCMCIA control ioctl that did not yet make it into Linus' tree:
> > > 
> > > Okay, this means at least one of my platforms is now dead as far as
> > > building new kernels for it, and nothing I can do about that.  Ho hum.
> > 
> > I don't get it.  Several of us had building problems for a few
> > days with some pasic driver.  We posted some bug reports and
> > some patches, but we put up with it for a few days...
> 
> What don't you get?

Why you said "building new kernels for it".
So it confused me.  It's not strictly a build issue,
it's a run-time issue.


> I've said each time the PCMCIA ioctl removal topic came up that it would
> give me this precise problem.  I've given details of _why_ it would cause
> me that problem.  It's gone ahead inspite of that.


---
~Randy
