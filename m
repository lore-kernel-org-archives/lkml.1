Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870Ab0AYTaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0AYTaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 14:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858Ab0AYTaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 14:30:16 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:32679 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0AYTaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:30:14 -0500
X-SpamScore: -5
X-BigFish: VPS-5(zz4015L62a3Lzz1202hzzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KWTI4X-01-1MB-02
X-M-MSG: 
Date: Mon, 25 Jan 2010 20:29:22 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile fixes for v2.6.33
Message-ID: <20100125192922.GQ2014@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 25 Jan 2010 19:29:25.0389 (UTC) FILETIME=[B42CB3D0:01CA9DF4]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile fixes for v2.6.33 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Thanks,

-Robert

The following changes since commit 92dcffb916d309aa01778bf8963a6932e4014d07:
  Linus Torvalds (1):
        Linux 2.6.33-rc5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Andi Kleen (1):
      oprofile/x86: add Xeon 7500 series support

Suravee Suthikulpanit (1):
      oprofile/x86: fix crash when profiling more than 28 events

 arch/x86/oprofile/nmi_int.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


