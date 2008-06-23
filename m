Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbYFWFe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbYFWFe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 01:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYFWFeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 01:34:20 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:44899 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751528AbYFWFeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 01:34:19 -0400
Message-ID: <485F3585.2080606@snapgear.com>
Date: Mon, 23 Jun 2008 15:32:53 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: ColdFire add support for kernel preemption
References: <200805010216.m412GT6t004096@goober>	<20080501143336.552e39e1.akpm@linux-foundation.org>	<481AC07A.6080707@snapgear.com>	<20080502083755.GA13973@Chamillionaire.breakpoint.cc> <20080502052235.eb9c336a.akpm@linux-foundation.org>
In-Reply-To: <20080502052235.eb9c336a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton wrote:
> On Fri, 2 May 2008 10:37:55 +0200 Sebastian Siewior <lkml@ml.breakpoint.cc> wrote:
> 
>>>>> Subject: [PATCH] m68knommu: ColdFire add support for kernel preemption
>>>> Please find a way to get your patch queue into linux-next so that others
>>>> get some visibility into what you're brewing earlier than
>>>> last-day-of-the-merge-window?
>>> Is a git tree the only way?
>> Others (Greg KH for instance, i2c) have quilt queues.
> 
> Yup.  Examples:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
> http://ozlabs.org/~rusty/kernel/rr-latest
> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-02-usb
> 
> Note how you can publish subsets of your patchset by bracketing them with
> "# MM_PATCHES_START" and "# MM_PATCHES_END" for -mm, and "#
> NEXT_PATCHES_START" and "# NEXT_PATCHES_END" for linux-next.

I decided to go the git route.

Here is a git tree for the collection of patches for the m68knommu
architecture that I intend for the 2.6.27 merge window.

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

I have created a general uclinux changes git tree as well,

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/uclinux.git for-linus

though currently I have nothing queued for that.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
