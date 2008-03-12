Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbYCLHLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbYCLHLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 03:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYCLHLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 03:11:46 -0400
Received: from www.tglx.de ([62.245.132.106]:45038 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbYCLHLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 03:11:45 -0400
Date: Wed, 12 Mar 2008 08:11:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gabriel C <nix.or.die@googlemail.com>
cc: Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>
Subject: Re: Clocksource tsc is always unstable with 2.6.25-* kernels and
 CONFIG_NO_HZ=y on my box
In-Reply-To: <47C32986.8010206@googlemail.com>
Message-ID: <alpine.LFD.1.00.0803120805060.3781@apollo.tec.linutronix.de>
References: <fa.FpheN5sIQ5rxoLHYuhxxf6uauVs@ifi.uio.no> <47C24517.7010204@shaw.ca> <alpine.LFD.1.00.0802250839240.7583@apollo.tec.linutronix.de> <47C2F350.1060107@googlemail.com> <alpine.LFD.1.00.0802252031180.7583@apollo.tec.linutronix.de>
 <47C32986.8010206@googlemail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Gabriel C wrote:
>
> > What happens if you add clocksource=acpi_pm and nohz=off to the kernel
> > commandline ?
> 
> Then the kernel boots and it seems to work.
>
> If you want I can build an debug kernel and boot with initcall_debug
> or anything else may help to find the problem, just let me know.

Sorry, this thread slipped out of my attention.

Is this still true with 2.6.25-rc5 ?

Thanks,

	tglx

