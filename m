Return-Path: <linux-kernel-owner+w=401wt.eu-S1751199AbXBMIeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199AbXBMIeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXBMIeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:34:14 -0500
Received: from mail.exanet.com ([212.143.73.109]:37029 "EHLO mr.exanet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbXBMIeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:34:13 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: ARP hidden patch vs. arp ignore/announce
Date: Tue, 13 Feb 2007 10:34:09 +0200
Message-ID: <A6FDE6B975803043804A49F12F49028E0F5757@hawk.exanet-il.co.il>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ARP hidden patch vs. arp ignore/announce
Thread-Index: AcdPSbqLSz9OYpgHQWqEdqDIRfH25g==
From: "Menny Hamburger" <menny@exanet.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the following document:
http://www.austintek.com/LVS/LVS-HOWTO/HOWTO/LVS-HOWTO.arp_problem.html
The following is noted:
"The risk is that other hosts can probe for VIP using unicast packets
for which the hidden flag always replies. I'll continue to support the
hidden flag 
for 2.4 and 2.6 to help existing setups but switching to the new device
flags (or other solutions) is recommended".

If there is currently no way to provide this functionality using
arp_ignore/arp_annonce/arp_filter or their friends, why is this still a
patch
And is not integrated into the mainline kernel?

Regards,
Menny

