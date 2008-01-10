Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbYAJVSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbYAJVSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYAJVSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:18:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50673 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYAJVSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:18:31 -0500
Message-ID: <47868B6D.6030208@zytor.com>
Date: Thu, 10 Jan 2008 13:17:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matthew <jackdachef@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ed Tomlinson <edt@aei.ca>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit
 applications(binaries) on 64bit system (Gentoo)
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>	 <e85b9d30712291504r2f4ef991w33f501ccf0d41c2b@mail.gmail.com>	 <200712300128.35476.mboton@gmail.com> <20080102084002.GA13636@elte.hu>	 <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com>	 <e85b9d30801080340y43fbd4c0sa9b6c9811c7391a1@mail.gmail.com>	 <47841C41.4060401@zytor.com> <e85b9d30801101310p485c7686o30b7cd581043712@mail.gmail.com>
In-Reply-To: <e85b9d30801101310p485c7686o30b7cd581043712@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew wrote:
>> If you *do* reproduce the problem that way, it would be extremely
>> helpful if you could enable CONFIG_DEBUG_INFO and provide the vmlinux
>> (not vmlinuz/bzImage) file that goes with the crash dump screenshot.
> 
> I *did* reproduce it that way and enabled the above mentioned option
> and the CONFIG_DEBUG_BUGVERBOSE=y thingy and CONFIG_FRAME_POINTER=y,
> too
> hope that's enough
> 
> here you go: http://kerneloftruth.neucode.org/other/crash_ia32_64/not_tainted/vmlinux
> (I hope it was uploaded completely):
> 
> md5sum: 0be124557bafebaebd69be2138329ef6
> sha256sum: 638d7a0dc36caa8eedd77e2ebeae6e8b54db74466f9d28f769c9cacf2ace0e0e
> 
> updated kernel-config:
> http://omploader.org/vYWhw/2.6.24-rc6-zen0_bisect%20(latest_config)
> 

Great!!  Downloading now.

Do you have the error dump output to go along with this, too?

Huge thanks,

	-hpa
