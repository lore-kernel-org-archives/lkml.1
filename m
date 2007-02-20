Return-Path: <linux-kernel-owner+w=401wt.eu-S965788AbXBTAra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965788AbXBTAra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965795AbXBTAra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:47:30 -0500
Received: from lucidpixels.com ([75.144.35.66]:45645 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965788AbXBTAr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:47:29 -0500
Date: Mon, 19 Feb 2007 19:47:23 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: e1000-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, linux.nics@intel.com, taroon-list@redhat.com
Subject: RHEL3 2.4.21-37a6smp 10GBps Intel 10GBps NIC: ixgb_clean_tx_irq:
 Detected Tx Unit Hang - Machine locks up.
Message-ID: <Pine.LNX.4.64.0702191940320.21239@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quick question,

I am using the latest ixgb driver (1.0.126) as stated both on Intel's 
website and here: http://sourceforge.net/forum/forum.php?forum_id=645203

After a number of hours, sometimes days, I will get this error on the 
console and the box locks up:

ixgb: eth2: ixgb_clean_tx_irq: Detected Tx Unit Hang

Intel told us that the 126 version of this driver was supposed to fix this 
problem.  Is there anyone from Intel on this list or someone who has dealt 
with this issue and has a potential fix?

The Intel Board is 10GBe PCI-X card in a HP DL385.

Can anyone offer some assistance with this issue?

Please CC as I am not on lkml or taroon mailing lists, thanks.

Justin.


