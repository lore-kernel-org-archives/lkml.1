Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbYCMDa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbYCMDa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 23:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYCMDav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 23:30:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:7447 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYCMDau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 23:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ZUTcaoAYFpZ1jV8Vc882wbkDtTe4LdD9RTb+sw7IzvzKjNHj8X8mmfxk8oLym9HleHqyOxeX9/QEb/3yTnvWxXNaU8rE1rvpsexpuc7udzk7iC7i0D6GGSH5CAYnZY8MOP5xslgZNUf1jdHK/WlQbIQ31drfT7Xam/D/yJQnbMk=
Message-ID: <47D89FE4.1070603@googlemail.com>
Date: Thu, 13 Mar 2008 04:30:44 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>
Subject: Re: Clocksource tsc is always unstable with 2.6.25-* kernels and
 CONFIG_NO_HZ=y on my box
References: <fa.FpheN5sIQ5rxoLHYuhxxf6uauVs@ifi.uio.no> <47C24517.7010204@shaw.ca> <alpine.LFD.1.00.0802250839240.7583@apollo.tec.linutronix.de> <47C2F350.1060107@googlemail.com> <alpine.LFD.1.00.0802252031180.7583@apollo.tec.linutronix.de> <47C32986.8010206@googlemail.com> <alpine.LFD.1.00.0803120805060.3781@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0803120805060.3781@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 25 Feb 2008, Gabriel C wrote:
>>> What happens if you add clocksource=acpi_pm and nohz=off to the kernel
>>> commandline ?
>> Then the kernel boots and it seems to work.
>>
>> If you want I can build an debug kernel and boot with initcall_debug
>> or anything else may help to find the problem, just let me know.
> 
> Sorry, this thread slipped out of my attention.
> 
> Is this still true with 2.6.25-rc5 ?

Yes it is , I'm running  2.6.25-rc5-00232-g93d7446 and it has the same problem.

> 
> Thanks,
> 
> 	tglx
> 
> 

Gabriel
