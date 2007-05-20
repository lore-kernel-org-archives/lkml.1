Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXETHDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXETHDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 03:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764682AbXETHDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 03:03:21 -0400
Received: from mtoichi16.ns.itscom.net ([219.110.2.186]:53068 "EHLO
	mtoichi16.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763896AbXETHDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 03:03:18 -0400
Date: Sun, 20 May 2007 15:59:48 +0900
From: Mattia Dongili <malattia@linux.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Zhang Rui <rui.zhang@intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Len Brown <lenb@kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [2.6.22-rc1-mm1] vaio laptop (SZ72B) immediately resumes after STR
Message-ID: <20070520065947.GA4880@inferi.kami.home>
References: <20070518071523.GA3195@inferi.kami.home> <20070518002240.bc08e811.akpm@linux-foundation.org> <20070519064829.GA15518@inferi.kami.home> <20070519000413.75badb6f.akpm@linux-foundation.org> <20070520061408.GA3325@inferi.kami.home> <20070519234723.5200a8b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070519234723.5200a8b4.akpm@linux-foundation.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc1-mm1-3 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 11:47:23PM -0700, Andrew Morton wrote:
> On Sun, 20 May 2007 15:14:08 +0900 Mattia Dongili <malattia@linux.it> wrote:
> 
> > On Sat, May 19, 2007 at 12:04:13AM -0700, Andrew Morton wrote:
> > > On Sat, 19 May 2007 15:48:29 +0900 Mattia Dongili <malattia@linux.it> wrote:
...
> > > > ok, git-acpi.patch is not the bad boy :)
> > 
> > but very very close:
> > acpi-driver-model-flags-and-platform_enable_wake.patch
> > 
> 
> Thanks very much for working that out - it saves lots of people heaps of
> pain.  I dropped the patch.

oh dear... and now, with the full series applied, I hit the
immediately-resuspend-after-resume someone already reported...

aargh
-- 
mattia
:wq!
