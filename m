Return-Path: <linux-kernel-owner+w=401wt.eu-S965862AbXBOKwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965862AbXBOKwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965861AbXBOKwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:52:14 -0500
Received: from mail.trixing.net ([87.230.125.58]:56697 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965858AbXBOKwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:52:14 -0500
Message-ID: <45D43B4C.6000600@l4x.org>
Date: Thu, 15 Feb 2007 11:51:56 +0100
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061220 Thunderbird/1.5.0.9 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: stelian@popies.net, linux-acpi@vger.kernel.org, linux-pm@osdl.org,
       adaplas@pol.net, dawes@xfree86.org,
       Linux kernel <linux-kernel@vger.kernel.org>
References: <45D43489.3060409@l4x.org> <20070215103639.GB27338@elf.ucw.cz> <45D438F2.2040607@l4x.org> <20070215104502.GO26240@elf.ucw.cz>
In-Reply-To: <20070215104502.GO26240@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.37
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: [linux-pm] Suspend to RAM, Sony Vaio PCG-SRX51P, lcd stays off
X-SA-Exim-Version: 4.2.1 (built Mon, 27 Mar 2006 14:12:04 +0200)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>>> I own an older Sony Vaio SRX51P, European Model, P3 based. s2ram
>>>> identifies it with
>>>>
>>>>     sys_vendor   = "Sony Corporation    "
>>>>     sys_product  = "PCG-SRX51P(DE)      "
>>>>     sys_version  = "01                  "
>>>>     bios_version = "R0232U2"
>>>>
>>>> Suspend to RAM by using "s2ram -v -m -f" actually works and the
>>>> laptop comes back to life, is accessible by network, etc. kudos
>>>> so far.
>>>> The only but serious problem is, that the lcd stays off after
>>>> resume. No matter what kind of options for s2ram I try, if I disable
>>> Is the _lcd_ off or the _backlight_ off? Use bright flashlight to
>>> tell.
>> The lcd. If you press the lid button you get the same effect (but you
>> cannot use it to turn the lcd on again :-(( ). But I'll doublecheck with
>> a flashlight nevertheless.
> 
> If lid button breaks the lcd, even in grub boot loader... then I'd
> call your machine broken hardware, complain to the manufacturer. (Are
> you at latest BIOS?)

No, you misunderstood me. If I press the lid button, the lcd goes off
and when I release it, it goes on again. But after a suspend cycle
even that does not revive the lcd.

Jan
