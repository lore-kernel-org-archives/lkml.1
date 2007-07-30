Return-Path: <linux-kernel-owner+w=401wt.eu-S937121AbXG3Noh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937121AbXG3Noh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 09:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763543AbXG3Noa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 09:44:30 -0400
Received: from anubis.lpbproductions.com ([38.119.36.60]:43490 "EHLO
	anubis.lpbproductions.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762950AbXG3No3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 09:44:29 -0400
Message-ID: <46ADEB30.5010002@erley.org>
Date: Mon, 30 Jul 2007 09:44:16 -0400
From: pat-lkml <pat-lkml@erley.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070729)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Bernhard Kaindl <bk@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: PCI Quirk / Hidden Bus Report
References: <469EDBA3.2000404@erley.org> <20070730115505.GP16817@stusta.de>
In-Reply-To: <20070730115505.GP16817@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the bump.  Any additional information needed?

Pat Erley

Adrian Bunk wrote:
> Bernhard?
> 
> cu
> Adrian
> 
> 
> On Wed, Jul 18, 2007 at 11:33:55PM -0400, pat-lkml wrote:
>> I received:
>>
>> PCI: Bus #0b (-#0e) is hidden behind transparent bridge #0a (-#0a) (try
>> 'pci=assign-busses')
>> Please report the result to linux-kernel to fix this permanently
>>
>> in my dmesg in 2.6.22, and am reporting it.  Context of message follows.
>>  Full dmesg output available on request.  This is a Clevo d900t laptop
>> motherboard, and everything works perfectly on it.
>>
>> Pat Erley
>>
>> --
>>
>> ENABLING IO-APIC IRQs
>> ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
>> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
>> Brought up 2 CPUs
>> migration_cost=22
>> NET: Registered protocol family 16
>> EISA bus registered
>> ACPI: bus type pci registered
>> PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
>> PCI: Not using MMCONFIG.
>> PCI: PCI BIOS revision 2.10 entry at 0xfd951, last bus=10
>> PCI: Using configuration type 1
>> Setting up standard PCI resources
>> ACPI: Interpreter enabled
>> ACPI: Using IOAPIC for interrupt routing
>> ACPI: PCI Root Bridge [PCI0] (0000:00)
>> PCI: Probing PCI hardware (bus 00)
>> PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
>> PCI quirk: region 1180-11bf claimed by ICH6 GPIO
>> PCI: Transparent bridge - 0000:00:1e.0
>> PCI: Bus #0b (-#0e) is hidden behind transparent bridge #0a (-#0a) (try
>> 'pci=assign-busses')
>> Please report the result to linux-kernel to fix this permanently
>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG_._PRT]
>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
>> ACPI: PCI Interrupt Link [LNKA] (IRQs 10) *11
>> ACPI: PCI Interrupt Link [LNKB] (IRQs 11) *10
>> ACPI: PCI Interrupt Link [LNKC] (IRQs 10) *5
>> ACPI: PCI Interrupt Link [LNKD] (IRQs 11) *10
>> ACPI: PCI Interrupt Link [LNKE] (IRQs *10)
>> ACPI: PCI Interrupt Link [LNKF] (IRQs *11)
>> ACPI: PCI Interrupt Link [LNKG] (IRQs 10) *0, disabled.
>> ACPI: PCI Interrupt Link [LNKH] (IRQs *11)
>> Linux Plug and Play Support v0.97 (c) Adam Belay
>> pnp: PnP ACPI init
>> ACPI: bus type pnp registered
>> pnp: PnP ACPI: found 12 devices
>> ACPI: ACPI bus type pnp unregistered
>> SCSI subsystem initialized
>> libata version 2.21 loaded.
>> PCI: Using ACPI for IRQ routing
>> PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
>> report
>> Time: tsc clocksource has been installed.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

