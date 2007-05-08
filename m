Return-Path: <linux-kernel-owner+w=401wt.eu-S967757AbXEHE3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967757AbXEHE3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 00:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967718AbXEHE3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 00:29:35 -0400
Received: from ns2.suse.de ([195.135.220.15]:45809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967611AbXEHE3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 00:29:34 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 8 May 2007 14:29:12 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 000 of 5] md: assorted bug fixes and minor features
Message-ID: <20070508142718.28571.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following are 5 patches for md suitable for 2.6.22.  None are needed for -stable.

Thanks
NeilBrown

 [PATCH 001 of 5] md: Move test for whether level supports bitmap to correct place.
 [PATCH 002 of 5] md: Stop using csum_partial for checksum calculation in md.
 [PATCH 003 of 5] md: Remove the slash from the name of a kmem_cache used by raid5.
 [PATCH 004 of 5] md: Allow reshape_position for md arrays to be set via sysfs.
 [PATCH 005 of 5] md: Improve partition detection in md array.
