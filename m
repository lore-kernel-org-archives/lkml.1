Return-Path: <linux-kernel-owner+w=401wt.eu-S1750895AbYKGROg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895AbYKGROg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 12:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYKGROT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 12:14:19 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:65442 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbYKGROS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 12:14:18 -0500
X-BigFish: VPS-17(zz62a3L936eQ4015Mzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K9Z3VC-01-3YJ-01
Date: Fri, 7 Nov 2008 18:13:40 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [git pull] OProfile fixes for v2.6.28
Message-ID: <20081107171339.GQ9785@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 07 Nov 2008 17:14:05.0200 (UTC) FILETIME=[3CC13100:01C940FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

please pull oprofile fixes for 2.6.28 for tip regression:

git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git oprofile-for-tip

Thanks,

-Robert

Andi Kleen (1):
      oprofile: Fix p6 counter overflow check

Carl Love (2):
      Cell OProfile: Incorrect local array size in activate spu profiling function
      Cell OProfile: Incorrect local array size in activate spu profiling function

Jesper Dangaard Brouer (1):
      Change UTF8 chars in Kconfig help text about Oprofile AMD barcelona

Nick Piggin (1):
      oprofile: fix memory ordering

Robert Richter (1):
      Revert "Cell OProfile: Incorrect local array size in activate spu profiling function"

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

