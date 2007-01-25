Return-Path: <linux-kernel-owner+w=401wt.eu-S1030583AbXAYVYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030583AbXAYVYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030579AbXAYVYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:24:34 -0500
Received: from server077.de-nserver.de ([62.27.12.245]:36344 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030581AbXAYVYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:24:33 -0500
Message-ID: <45B9200C.7070808@profihost.com>
Date: Thu, 25 Jan 2007 22:24:28 +0100
From: Stefan Priebe - FH <studium@profihost.com>
User-Agent: Mozilla Thunderbird 1.0.7 (Windows/20050923)
X-Accept-Language: de-DE, de, en-us, en
MIME-Version: 1.0
To: Stephen Evanchik <evanchsa@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA ahci Bug in 2.6.19.x
References: <45B46FA0.2060901@profihost.com> <a71293c20701220600v426f0efdyc23dd945852f71c0@mail.gmail.com>
In-Reply-To: <a71293c20701220600v426f0efdyc23dd945852f71c0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 84.133.245.39
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello....

Nobody here who cares???

Stefan

Stephen Evanchik schrieb:
> On 1/22/07, Stefan Priebe - FH <studium@profihost.com> wrote:
> 
>> I've an Asus A8V Mainboard which works wonderful with a 2.6.18.X kernel.
>> But i cannot use the SATA Controller with a 2.6.19.x Kernel.
> 
> 
> I also have an Asus A8V motherboard that cannot boot a newer kernel
> because the SATA controller does not come up properly. I have tried
> kernels 2.6.19.2 and 2.6.20-rc5 with no luck. It looks like later
> kernels don't recognize the proper IRQ of the device as compared to
> the 2.6.18 boot logs.
> 
>> "ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 21"
>> "ahci 0000:00:0f.0: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl IDE
>> mode"
>> "ahci 0000:00:0f.0: flags: 64bit ncq pm led clo pmp pio slum part "
>> "ata1: SATA max UDMA/133 cmd 0xFFFFC20000004D00 ctl 0x0 bmdma 0x0 irq 
>> 1277"
>> "ata2: SATA max UDMA/133 cmd 0xFFFFC20000004D80 ctl 0x0 bmdma 0x0 irq 
>> 1277"
>> "ata3: SATA max UDMA/133 cmd 0xFFFFC20000004E00 ctl 0x0 bmdma 0x0 irq 
>> 1277"
>> "ata4: SATA max UDMA/133 cmd 0xFFFFC20000004E80 ctl 0x0 bmdma 0x0 irq 
>> 1277"
> 
> 
> Similar output as above.
> 
> 
> Does any one have any ideas?
> 
> 
> Stephen

