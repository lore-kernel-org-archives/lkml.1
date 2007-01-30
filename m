Return-Path: <linux-kernel-owner+w=401wt.eu-S1751757AbXA3Tdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbXA3Tdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbXA3Tdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:33:46 -0500
Received: from mail.tmr.com ([64.65.253.246]:57268 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbXA3Tdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:33:45 -0500
Message-ID: <45BF9D6D.1040403@tmr.com>
Date: Tue, 30 Jan 2007 14:33:01 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <1a297b360701300930m90a09bbp30bed58c9c9bf456@mail.gmail.com>
In-Reply-To: <1a297b360701300930m90a09bbp30bed58c9c9bf456@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manu Abraham wrote:
> On 1/30/07, Greg KH <greg@kroah.com> wrote:
>> Free Linux Driver Development!
>>
>> Yes, that's right, the Linux kernel community is offering all companies
>> free Linux driver development.  No longer do you have to suffer through
>> all of the different examples in the Linux Device Driver Kit, or pick
>> through the thousands of example drivers in the Linux kernel source
>> tree trying to determine which one is the closest to what you need to
>> do.
>>
>> All that is needed is some kind of specification that describes how your
>> device works, or the email address of an engineer that is willing to
>> answer questions every once in a while.  A few sample devices might be
>> good to have so that debugging doesn't have to be done by email, but if
>> necessary, that can be done.
>>
>> In return, you will receive a complete and working Linux driver that is
>> added to the main Linux kernel source tree.  The driver will be written
>> by some of the members of the Linux kernel developer community (over
>> 1500 strong and growing).  This driver will then be automatically
>> included in all Linux distributions, including the "enterprise" ones.
>> It will be automatically kept up to date and working through all Linux
>> kernel API changes.  This driver will work with all[1] of the different
>> CPU types supported by Linux, the largest number of CPU types supported
>> by any operating system ever before in the history of computing.
>>
>> As for support, the driver will be supported through email by the
>> original developers, when they can help out, and by the "enterprise"
>> Linux distributors as part of their service agreements with their
>> customers.
>>
>> If your company is worried about NDA issues surrounding your device's
>> specifications, we have arranged a program with OSDL/TLF's Tech Board to
>> provide the legal framework where a company can interact with a member
>> of the kernel community in order to properly assure that all needed NDA
>> requirements are fulfilled.
> 
> 
> Sounds very nice indeed. Just happened to do a driver in a similar
> status, where the vendor did not want to make the specs and other
> stuff open, but was in a position to support an OSS driver for the
> STB0899 demodulator driver from ST Microelectronics
> 
> I think many vendors will be ready to jump in.
> 
> the STB0899 demodulator driver is now available at
> 
> http://linuxtv.org/hg/~manu/stb0899-c5
> 
> It needs some fixes with regards to our DVB API. (bumping it up to 3.2
> from 3.1) It's almost ready to rock now, with new delivery systems.
> 
Let us know when it's ready, since the invite is here, success stories 
of people using the program could go here as well.

Greg, did this go to the "announce" group as well? It should, some 
people read that even if they can't cope with LKML volume.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
