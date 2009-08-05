Return-Path: <linux-kernel-owner+w=401wt.eu-S934182AbZHEKrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934182AbZHEKrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933975AbZHEKrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:47:40 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:5363 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195AbZHEKrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:47:40 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz62a3L4015Lzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNWGN4-03-8NY-01
Date: Wed, 5 Aug 2009 12:47:27 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] OProfile updates for tip
Message-ID: <20090805104726.GC14610@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 Aug 2009 10:47:28.0341 (UTC) FILETIME=[204BA850:01CA15BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull for tip/oprofile from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Thanks,

-Robert

The following changes since commit c550091edd6fac2ed9dac1b30d986b6c58b216fa:
  Robert Richter (1):
        x86/oprofile: Small coding style fixes

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Andrew Morton (1):
      arch/x86/oprofile/op_model_amd.c: fix op_amd_handle_ibs() return type

Robert Richter (1):
      Revert "x86: oprofile/op_model_amd.c set return values for op_amd_handle_ibs()"

 arch/x86/oprofile/op_model_amd.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

