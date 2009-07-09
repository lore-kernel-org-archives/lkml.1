Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbZGITKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbZGITKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 15:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZGITKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 15:10:46 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:36095 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbZGITKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 15:10:45 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz4015L62a3Lzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KMJ3XE-02-X85-01
Date: Thu, 9 Jul 2009 21:10:32 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile fixes for v2.6.31-rc2
Message-ID: <20090709191031.GH3226@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Jul 2009 19:10:33.0616 (UTC) FILETIME=[EEF7D900:01CA00C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile fixes for v2.6.31-rc2 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git fixes-for-linus

Thanks,

-Robert


The following changes since commit faf80d62e44dc627efb741f48db50c1858d1667c:
  Linus Torvalds (1):
        Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git fixes-for-linus

Maynard Johnson (1):
      oprofile: reset bt_lost_no_mapping with other stats

Robert Richter (3):
      Merge commit 'v2.6.30' into oprofile/master
      x86/oprofile: rename kernel parameter for architectural perfmon to arch_perfmon
      Merge branches 'oprofile/fixes' and 'oprofile/stable' into oprofile/fixes-for-linus

 Documentation/kernel-parameters.txt |    4 ++--
 arch/x86/oprofile/nmi_int.c         |    2 +-
 drivers/oprofile/oprofile_stats.c   |    1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

