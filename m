Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbYKWLHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbYKWLHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 06:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757505AbYKWLHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 06:07:44 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:49558 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493AbYKWLHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 06:07:43 -0500
X-BigFish: VPS-17(zz62a3L936eQ4015Mzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KAS9KK-01-480-01
Date: Sun, 23 Nov 2008 12:06:10 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [git pull] OProfile fixes for v2.6.28
Message-ID: <20081123110610.GC14700@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 23 Nov 2008 11:06:42.0761 (UTC) FILETIME=[910BEB90:01C94D5B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

please pull oprofile fixes for 2.6.28 for tip regression:

git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git oprofile-for-tip

There is only one fix:

Eric Dumazet (1):
      oprofile: fix an overflow in ppro code

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

