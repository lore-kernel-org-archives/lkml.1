Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbXGTFNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbXGTFNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 01:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbXGTFNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 01:13:07 -0400
Received: from [212.12.190.65] ([212.12.190.65]:32987 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750986AbXGTFNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 01:13:05 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-raid@vger.kernel.org
Subject: [RFH] Partion table recovery
Date: Fri, 20 Jul 2007 08:13:03 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707200813.03553.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As always, a good friend of mine managed to scratch my partion table by 
cat'ing /dev/full into /dev/sda.  I was able to push him out of the way, but 
at least the first 100MB are gone.  I can probably live without the first 
partion, but there are many partitions after that, which I hope should 
easily be recoverable.

I tried parted, but it's not working out for me.  Does anybody know of a 
simple partition recovery tool, that would just scan the disk for lost 
partions?


Thanks!

--
Al

