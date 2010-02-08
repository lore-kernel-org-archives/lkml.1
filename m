Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab0BHUkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:40:47 -0500
Received: from www.tglx.de ([62.245.132.106]:45846 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab0BHUkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:40:46 -0500
Date: Mon, 8 Feb 2010 21:40:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Mohr <andi@lisas.de>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
 (2.6.33-rc6/7)
In-Reply-To: <alpine.LFD.2.00.1002082117210.2811@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002082139360.2811@localhost.localdomain>
References: <20100206142141.GA12871@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002061534020.2811@localhost.localdomain> <20100207191949.GA23665@rhlx01.hs-esslingen.de> <20100208053830.GA7128@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081010330.2811@localhost.localdomain>
 <20100208093719.GA15428@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081038430.2811@localhost.localdomain> <20100208194734.GA20316@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002082117210.2811@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010, Thomas Gleixner wrote:
> On Mon, 8 Feb 2010, Andreas Mohr wrote:
> Which compiler version are you using ?
> 
> Can you please provide the disassembly of kernel/time/timekeeping.o ?

Is that NMI watchdog hit fully reproducible ?

Thanks,

	tglx
