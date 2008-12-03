Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYLCRRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYLCRRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYLCRR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:17:27 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:22916 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYLCRR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:17:26 -0500
X-BigFish: VPS-15(zz62a3L936eQ4015Mzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBB9CM-01-8WT-01
Date: Wed, 3 Dec 2008 18:16:38 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [git pull] OProfile fixes for v2.6.28
Message-ID: <20081203171637.GJ11656@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Dec 2008 17:17:14.0962 (UTC) FILETIME=[FC9A1320:01C9556A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

please pull oprofile fixes for 2.6.28 for tip regression:

git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git oprofile-for-tip

There are these fixes:

Eric Dumazet (1):
      oprofile: fix CPU unplug panic in ppro_stop()

William Cohen (1):
      x86/oprofile: fix Intel cpu family 6 detection

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

