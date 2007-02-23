Return-Path: <linux-kernel-owner+w=401wt.eu-S932756AbXBWXVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756AbXBWXVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932764AbXBWXVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:21:32 -0500
Received: from vms048pub.verizon.net ([206.46.252.48]:42205 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbXBWXVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:21:31 -0500
Date: Fri, 23 Feb 2007 18:21:26 -0500
From: "Tom Morrison" <Tom.Morrison@Verizon.net>
Subject: RE: Problems with init of Marvell PCI Express SATA Card
In-reply-to: <20070224001829.2b444773@lxorguk.ukuu.org.uk>
To: "Alan" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>
Reply-to: <Tom.Morrison@Verizon.net>
Message-id: <CJEDIOAEPEPAEFLDLKIBAEJMCDAA.Tom.Morrison@Verizon.net>
MIME-version: 1.0
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Importance: Normal
X-Priority: 3 (Normal)
X-MSMail-priority: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

Where do I look in the kernel to see if there is
'driver support' present based upon the card?

As I mentioned as well, the same driver is used
for the PCI Driver (using 6042 chip). So, at some
level, the support is there.

The key is does Linux *Kernel* support for PCI
Express have support for this card? Which goes
back to the initial question - where/how do I
look to see if it does????

thanks Alan for any more insight!

Tom

-----Original Message-----
>> Alan Wrote:
>>
>> > Tom Wrote:
>> > What am I doing wrong? Do I need to have
>> > the PCI ids in the kernel match identically
>> > what is on pci express sata card device?
>>
>> And driver support which may or may not be present depending on the card.

