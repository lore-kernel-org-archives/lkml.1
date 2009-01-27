Return-Path: <linux-kernel-owner+w=401wt.eu-S1751885AbZA0Gfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbZA0Gfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 01:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZA0GfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 01:35:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:50920 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZA0GfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 01:35:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wApO331+ifeSn9xMTHtQCGJH3IYGiNURHT9UfY53xWwcML6aiWdeAQuhTUbvYO6Fle
         GkvvFIrv/fcogQifs3cw0m9SUU/8JB3JASa9MiGullnMuHPX9bnIBC8KxQYq4a1P7JEo
         9YbLdDqP9pyrjVUvnal6dOyl9SzgFqxZuKS2c=
MIME-Version: 1.0
In-Reply-To: <497DCB15.7030404@turknet.net.tr>
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
	 <alpine.LNX.1.10.0901261059560.5377@jikos.suse.cz>
	 <497DCB15.7030404@turknet.net.tr>
Date: Tue, 27 Jan 2009 12:05:18 +0530
Message-ID: <3f9a31f40901262235k1c1fec76q41fb007f6e7cb22f@mail.gmail.com>
Subject: Re: [TRIVIAL PATCH 00/20] Fix misspelling of "firmware"
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: Jiri Kosina <jkosina@suse.cz>, Nick Andrew <nick@nick-andrew.net>,
       Trivial Kernel Patches <trivial@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 8:09 PM, Tarkan Erimer
<tarkan.erimer@turknet.net.tr> wrote:
> On 01/26/2009 12:00 PM, Jiri Kosina wrote:
>>
>> On Mon, 26 Jan 2009, Nick Andrew wrote:
>>
>>
>>>
>>> Fix more misspellings of "firmware" which I noticed in v2.6.29-rc2. All
>>> are
>>> comment changes.
>>> Nick.
>>> ---
>>>
>>> Nick Andrew (20):
>>>       Fix misspelling of firmware in iwl-agn.c
>>>       Fix misspelling of firmware in iwl3945-base.c
>>>       Fix misspelling of firmware in hpmain.c
>>>       Fix misspelling of firmware in head_64.S
>>>       Fix misspelling of firmware in aica.c
>>>       Fix misspelling of firmware in pss.c
>>>       Fix misspelling of firmware in disk.c
>>>       Fix misspelling of firmware in libata.h
>>>       Fix misspelling of firmware in ChangeLog.history
>>>       Fix misspelling of firmware in ueagle-atm.c
>>>       Fix misspelling of firmware in pci.c
>>>       Fix misspelling of firmware in cmd.c
>>>       Fix misspelling of firmware in ipw2200.c
>>>       Fix misspelling of firmware in ipw2100.c
>>>       Fix misspelling of firmware in tg3.c
>>>       Fix misspelling of firmware in sb1250-mac.c
>>>       Fix misspelling of firmware in thinkpad_acpi.c
>>>       Fix misspelling of "firmware" in ip27-smp.c
>>>       Fix misspelling of "firmware" in firmware.txt
>>>       Fix misspelling of "firmware" in ia64-kvm.txt
>>>
>>
>> I will fold all this into single patch and apply.
>>
>> Thanks,
>>
>>
>
> "Fix misspelling of firmware in tg3.c" didn't help me to solve tg3 firmware
> issue which I submitted via "[BUG] tg3 module problem on Linux-2.6.29-rc1-2"
> subjected email at 21st of Jan. I re-compiled 2.6.29-rc2 with this patch and
> still having the same error message :
>
> Using mkinitramfs-kpkg to build the ramdisk.
> W: Possible missing firmware
> /lib/firmware/2.6.29-rc2-git1/tigon/tg3_tso5.bin for module tg3
> W: Possible missing firmware /lib/firmware/2.6.29-rc2-git1/tigon/tg3_tso.bin
> for module tg3
> W: Possible missing firmware /lib/firmware/2.6.29-rc2-git1/tigon/tg3.bin for
> module tg3
>
>

I send post to your original thread and also also CC to concern persons.

--
JSR
