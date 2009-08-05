Return-Path: <linux-kernel-owner+w=401wt.eu-S933617AbZHEDG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbZHEDG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 23:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933399AbZHEDG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 23:06:56 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:52820 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389AbZHEDGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 23:06:55 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Strange wireless card?
Date: Tue, 04 Aug 2009 23:06:35 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5; KDE/4.2.4; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
Content-disposition: inline
Message-id: <200908042306.36043.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Can anyone tell me if this pci wireless card is supported, or what its 
status is?

>From lspci -v:
01:06.0 Ethernet controller: Marvell Technology Group Ltd. 88w8335 [Libertas] 802.11b/g Wireless (rev 03)
        Subsystem: Netgear WG311v3 802.11g Wireless PCI Adapter

I have built a 2.6.31-rc5 kernel with the Marvel stuffs all enabled, but
even a modprobe mwl8k, while apparently loading the driver, doesn't create
any wireless devices in /dev.

Thanks for any pointers.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

Do not underestimate the power of the Force.

