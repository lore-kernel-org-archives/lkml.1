Return-Path: <linux-kernel-owner+w=401wt.eu-S1762152AbXGTN2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762152AbXGTN2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 09:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbXGTN2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 09:28:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42368 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756801AbXGTN2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 09:28:23 -0400
Date: Fri, 20 Jul 2007 14:35:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Felipe Contreras" <felipe.contreras@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: ata_piix broken in 2.6.22
Message-ID: <20070720143510.6ce81c09@the-village.bc.nu>
In-Reply-To: <94a0d4530707200626r2b50146bs55e268033ceab4b0@mail.gmail.com>
References: <94a0d4530707200626r2b50146bs55e268033ceab4b0@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> ata_piix 0000:00:1f.2: version 2.11
> ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
> ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 16
> ata_piix 0000:00:1f.2: 0x1F0 IDE port busy
> ata_piix 0000:00:1f.2: 0x170 IDE port busy
> ata_piix 0000:00:1f.2: no available legacy port

You appear to have old IDE compiled in as well and finding the device
first
