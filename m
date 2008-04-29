Return-Path: <linux-kernel-owner+w=401wt.eu-S1762696AbYD2VIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762696AbYD2VIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbYD2VHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:07:52 -0400
Received: from xenotime.net ([66.160.160.81]:49662 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756035AbYD2VHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:07:51 -0400
Date: Tue, 29 Apr 2008 14:07:44 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Adrian Bunk <bunk@kernel.org>,
       "Denis V. Lunev" <den@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: pcmcia_ioctl.c compile error
Message-Id: <20080429140744.64d63576.rdunlap@xenotime.net>
In-Reply-To: <1209502988.24729.31.camel@brick>
References: <20080429182709.GB2898@cs181133002.pp.htv.fi>
	<20080429201704.GA31311@flint.arm.linux.org.uk>
	<20080429135902.504b6362.rdunlap@xenotime.net>
	<1209502988.24729.31.camel@brick>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 14:03:07 -0700 Harvey Harrison wrote:

> On Tue, 2008-04-29 at 13:59 -0700, Randy Dunlap wrote:
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
> > 
> 
> I believe Russell is referring to the removal of the ioctl, not the
> compile breakage.

Oh, thanks.  I couldn't tell from the text.

---
~Randy
