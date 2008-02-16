Return-Path: <linux-kernel-owner+w=401wt.eu-S1758989AbYBPSic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbYBPSic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 13:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbYBPSiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 13:38:22 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:8769 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753432AbYBPSiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 13:38:21 -0500
X-Trace: 684022743/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAFu8tkdRAVlC/2dsb2JhbACBWasE
Subject: Current git very broken on the Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: linux-sh@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 18:38:00 +0000
Message-Id: <1203187080.6737.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will seek to bisect this, but I have just updated my sources to the
latest git and it is not booting at all on the Dreamcast.

With early printk on, I get nothing more than this before an instant
reboot:

[    0.000000] Linux version 2.6.25-rc2-10953-g52065cd
(adrian@bossclass) (gcc version 3.4.6) #511 PREEMPT Sat Feb 16 18:31:43
GMT 2008
[    0.000000] console [sercon0] enabled
[    0.000000] Booting machvec: Sega Dreamcast


