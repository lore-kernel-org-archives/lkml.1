Return-Path: <linux-kernel-owner+w=401wt.eu-S1764346AbZAQQXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764346AbZAQQXb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbZAQQXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:23:22 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:14042 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZAQQXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:23:22 -0500
X-BigFish: VPS-6(zz62a3L4015Mzzzzz32i6bh43j)
X-WSS-ID: 0KDMIUI-01-Q70-01
Date: Sat, 17 Jan 2009 17:23:09 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] oprofile fixes for tip
Message-ID: <20090117162309.GD21604@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Jan 2009 16:23:10.0100 (UTC) FILETIME=[E31A2D40:01C978BF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

you can pull from here:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git fixes

Thanks,

-Robert

The following changes since commit c59765042f53a79a7a65585042ff463b69cb248c:
  Linus Torvalds (1):
        Linux 2.6.29-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git fixes

Robert Richter (1):
      oprofile: fix uninitialized use of struct op_entry

 drivers/oprofile/cpu_buffer.c |    5 +++++
 drivers/oprofile/cpu_buffer.h |    7 +++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

