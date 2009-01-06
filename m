Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbZAFAfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbZAFAfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZAFAfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:35:37 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42850 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750730AbZAFAfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:35:37 -0500
Message-ID: <4962A756.2070507@sgi.com>
Date: Mon, 05 Jan 2009 16:35:34 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: compiling error
References: <49629225.1030104@sun.com>
In-Reply-To: <49629225.1030104@sun.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> In file included from arch/x86/mach-generic/summit.c:16:
> /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:
> In function â€˜cpu_mask_to_apicid_andâ€™:
> /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:179:
> error: â€˜GFP_ATOMICâ€™ undeclared (first use in this function)
> /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:179:
> error: (Each undeclared identifier is reported only once
> /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:179:
> error: for each function it appears in.)
> 
> YH
> 

Hi Yinghai,

Thanks for catching this, I'm looking at it now.  We had a bit of a power
problem here and have been down for a while.

Thanks,
Mike
