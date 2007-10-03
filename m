Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbXJCURh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbXJCURh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 16:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbXJCUR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 16:17:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50338 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbXJCUR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 16:17:28 -0400
Message-ID: <4703F8D4.90500@garzik.org>
Date: Wed, 03 Oct 2007 16:17:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: git-misc-all updated
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Just updated jgarzik/misc-2.6.git#ALL...

'ALL' meta-branch contains these branches, exported for review and testing:

dmi-const	DMI subsystem constification
		--> added your fix/warning patches

isdn-cleanups	ISDN subsystem cleanups for 2.6.24
		--> no word from Karsten after repeated pings
		--> added another couple code movement patches
		    (moved from branch isdn-pci to this one)

pciseg		x86/x86-64 PCI domain support

sas		new drivers broadsas, mvsas
		--> new branch; this is my devel tree for these drivers

Regards,

	Jeff



