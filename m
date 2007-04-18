Return-Path: <linux-kernel-owner+w=401wt.eu-S1030995AbXDRCDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030995AbXDRCDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 22:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031007AbXDRCDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 22:03:11 -0400
Received: from holomorphy.com ([66.93.40.71]:46402 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030995AbXDRCDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 22:03:10 -0400
Date: Tue, 17 Apr 2007 19:03:29 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418020329.GS2986@holomorphy.com>
References: <46241677.7060909@bigpond.net.au> <20070417025704.GM8915@holomorphy.com> <462445EC.1060306@bigpond.net.au> <20070417053147.GN8915@holomorphy.com> <46246A7C.8050501@bigpond.net.au> <20070417064109.GP8915@holomorphy.com> <46247E86.5090706@bigpond.net.au> <20070417104141.GV8915@holomorphy.com> <4624D027.4040500@bigpond.net.au> <462565EF.4030200@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462565EF.4030200@bigpond.net.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Peter Williams wrote:
> >William Lee Irwin III wrote:
> >>I was tempted to restart from scratch given Ingo's comments, but I
> >>reconsidered and I'll be working with your code (and the German
> >>students' as well). If everything has to change, so be it, but it'll
> >>still be a derived work. It would be ignoring precedent and failure to
> >>properly attribute if I did otherwise.
> >
> >I can give you a patch (or set of patches) against the latest git 
> >vanilla kernel version if that would help.  There have been changes to 
> >the vanilla scheduler code since 2.6.20 so the latest patch on 
> >sourceforge won't apply cleanly.  I've found that implementing this as a 
> >series of patches rather than one big patch makes it easier fro me to 
> >cope with changes to the underlying code.
> 
On Wed, Apr 18, 2007 at 10:27:27AM +1000, Peter Williams wrote:
> I've just placed a single patch for plugsched against 2.6.21-rc7 updated 
> to Linus's git tree as of an hour or two ago on sourceforge:
> <http://downloads.sourceforge.net/cpuse/plugsched-6.5-for-2.6.21-rc7.patch>
> This should at least enable you to get it to apply cleanly to the latest 
> kernel sources.  Let me know if you'd also like this as a quilt/mq 
> friendly patch series?

A quilt-friendly series would be most excellent if you could arrange it.

Thanks.


-- wli
