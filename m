Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbZIFRBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbZIFRBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 13:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbZIFRBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 13:01:35 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:34333 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021AbZIFRBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 13:01:35 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: linux-kernel@vger.kernel.org
Subject: 2.6.31-rc9, my buildit26 script fails, make xconfig is broken
Date: Sun, 06 Sep 2009 13:01:19 -0400
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8; KDE/4.3.0; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <200909061301.19312.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

My buildit26 script fails at the end, with this message:

scripts/kconfig/qconf arch/x86/Kconfig
make[1]: *** [xconfig] Illegal instruction
make: *** [xconfig] Error 2

And I get the same error if I do it by hand.

Fix?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

poor power conditioning
