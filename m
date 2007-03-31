Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbXCaLOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbXCaLOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 07:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbXCaLOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 07:14:10 -0400
Received: from brick.kernel.dk ([62.242.22.158]:11610 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbXCaLOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 07:14:08 -0400
Date: Sat, 31 Mar 2007 13:08:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [3/4] 2.6.21-rc5: known regressions (v2)
Message-ID: <20070331110855.GG6246@kernel.dk>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070330213220.GO14134@stusta.de> <b6a2187b0703301952s6042fbfdu2e15e0f868a958f4@mail.gmail.com> <20070331031650.GR14134@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331031650.GR14134@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31 2007, Adrian Bunk wrote:
> On Sat, Mar 31, 2007 at 10:52:59AM +0800, Jeff Chua wrote:
> > On 3/31/07, Adrian Bunk <bunk@stusta.de> wrote:
> > 
> > >Subject    : ThinkPad doesn't resume from suspend to RAM
> > >References : http://lkml.org/lkml/2007/2/27/80
> > >             http://lkml.org/lkml/2007/2/28/348
> > >Submitter  : Jens Axboe <jens.axboe@oracle.com>
> > >             Jeff Chua <jeff.chua.linux@gmail.com>
> > >Status     : unknown
> > 
> > Fixed with CONFIG_NO_HZ unset and patch from Maxim
> > (http://lkml.org/lkml/2007/3/29/108).
> 
> Thanks for this information.
> 
> Jens, does suspend to RAM also work for you with the latest -git?

Yep, it does, no problems since the last -rc.

-- 
Jens Axboe

