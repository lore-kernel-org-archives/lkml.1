Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbZCLXhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbZCLXhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 19:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbZCLXha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 19:37:30 -0400
Received: from sov-mail-b0017.gradwell.net ([193.84.87.41]:54548 "EHLO
	sov-mail-b0017.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019AbZCLXh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 19:37:29 -0400
Date: Thu, 12 Mar 2009 23:37:24 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Is there an "official" way to get the PCI BIOS revision under
 Linux?
Message-ID: <20090312233724.6ccca68f@lithium.local.net>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apart from looking at the messages in dmesg when booting up, is there
another way to get the PCI BIOS revision (i.e 2.1, 2.2 and 2.3) under
Linux. I've grepped the sources but under x86 architecture, apparently
the initalisation code only shows out the revision in the syslogs, but
doesn't save it anywhere (I know, every byte counts), but is there a
way to get at it without needing to reboot and read the kernel's
printk output?

Thanks,
Alex
-- 
http://www.munted.org.uk

Fearsome grindings.
