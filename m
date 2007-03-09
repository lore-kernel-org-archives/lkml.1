Return-Path: <linux-kernel-owner+w=401wt.eu-S964883AbXCILwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883AbXCILwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964935AbXCILwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:52:16 -0500
Received: from hempcity.net ([81.171.100.190]:50286 "EHLO hempcity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964883AbXCILwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:52:15 -0500
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2007 06:52:15 EST
Message-ID: <36417.84.81.1.164.1173440696.squirrel@webmail.coolzero.info>
Date: Fri, 9 Mar 2007 12:44:56 +0100 (CET)
Subject: Re: PCI failures during boot
From: "Jim van Wel" <jim@coolzero.info>
To: linux-kernel@vger.kernel.org
Reply-To: jim@coolzero.info
User-Agent: SquirrelMail/1.4.8-4.el4
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Please try first a newer kernel of FC6.

2.6.19-1.2911.6.5.fc6

That's 2.6.19.7.

That's the newest one.

Greetings,
Jim,

> Hi,
>
> I just bought a brand new notebook and wanted to install FC6 on it.
Unfornately there are some issues reported by the console during boot.
Here are some reported errors, I attached the full dmesg and other
information just in case.
>
> ACPI: bus type pci registered
> PCI: Using MMCONFIG at e0000000
> ACPI: Interpreter enabled
> ACPI: Using IOAPIC for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> PCI: Probing PCI hardware (bus 00)
> PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.2
> Boot video device is 0000:01:00.0
> PCI: Transparent bridge - 0000:00:1e.0
> PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06 (-#07) (try
'pci=assign-busses')
> Please report the result to linux-kernel to fix this permanently
>
> and later:
>
> PCI: Using ACPI for IRQ routing
> PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
report
> PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.0
> PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.0
> NetLabel: Initializing
> NetLabel:  domain hash size = 128
>
> I currently can't update my kernel version and I'm running a
> 2.6.18-1.2798.fc6 kernel.
>
> Could anybody give me some advices please ?
> --
> Francis
>



