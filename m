Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbXGIBaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbXGIBaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 21:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbXGIBaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 21:30:08 -0400
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:25647 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754830AbXGIBaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 21:30:07 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jul 2007 21:30:07 EDT
X-YMail-OSG: Tsphkg8VM1n23b3ECH0ePzADsYRJLJEwXSfhpDLo2s_rr0HxyVCeKKtdxliIQJ8s724vu.Zw2RuTrN8jp3g6y9ibTcveLKY74LUtYeuvT4.oxMqrudc-
Subject: [BUG] IT8212 libata driver *still* hard-freezes system on boot on
	2.6.22 final.
From: Rodney Gordon II <meff@spherevision.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 20:23:24 -0500
Message-Id: <1183944204.8932.8.camel@ghreen.sphere>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Have been quite busy, and I regret I haven't tried a rc kernel in
awhile, but, this bug has gone un-fixed still.. Thought I'd throw in
another "heads up"..

2.6.22 hang: http://spherevision.org/sync/visual/itelock.jpg
lspci -vvv: http://spherevision.org/sync/tmp/lspci.out

Pentium-D 830 3.0GHz Dualcore on a ASUS P5LD2 with latest bios rev.
1804.

SysRq does not work when this locks up.

Patches, info, things to try, anything is welcome, I am available for
awhile now and will try anything to get this working.

Cheers,
-r

