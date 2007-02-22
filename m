Return-Path: <linux-kernel-owner+w=401wt.eu-S1751767AbXBVSnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbXBVSnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 13:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbXBVSnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 13:43:10 -0500
Received: from tag.witbe.net ([81.88.96.48]:49243 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbXBVSnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 13:43:08 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Adrian Bunk'" <bunk@stusta.de>, "'Patrick Ale'" <patrick.ale@gmail.com>
Cc: "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: RE: [SKY2] Does anyone have this driver working?
Date: Thu, 22 Feb 2007 19:43:03 +0100
Organization: AS2917.net
Message-ID: <049601c756b1$4c304360$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <20070222183231.GB8603@stusta.de>
Thread-Index: AcdWr9qXpmr3VYYqSACoaJ+F+aqTPAAAUAug
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
 
> > I was wondering if any of you ever got the sky2 driver working
> 
> there are many people who are successfully using this card.

I have :
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:04:00.0 to 64
sky2 0000:04:00.0: v1.13 addr 0xff8fc000 irq 19 Yukon-EC (0xb6) rev 2
sky2 eth0: addr 00:18:f3:e0:5d:d4
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:03:00.0 to 64
sky2 0000:03:00.0: v1.13 addr 0xff7fc000 irq 16 Yukon-EC (0xb6) rev 2
sky2 eth1: addr 00:18:f3:e0:36:fd

and a wonderfully working eth0 interface...
Kernel : 2.6.19+ up to 2.6.21-rc1

Regards,
Paul

