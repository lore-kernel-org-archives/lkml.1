Return-Path: <linux-kernel-owner+w=401wt.eu-S1751827AbXLGFl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbXLGFl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 00:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXLGFlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 00:41:44 -0500
Received: from ns2.suse.de ([195.135.220.15]:45773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbXLGFlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 00:41:44 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 7 Dec 2007 16:41:36 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 000 of 3] md: a few little patches
Message-ID: <20071207163806.7539.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following 3 patches for md provide some code tidyup and a small
functionality improvement.
They do not need to go into 2.6.24 but are definitely appropriate 25-rc1.

(Patches made against 2.6.24-rc3-mm2)

Thanks,
NeilBrown


 [PATCH 001 of 3] md: raid6: Fix mktable.c
 [PATCH 002 of 3] md: raid6: clean up the style of raid6test/test.c
 [PATCH 003 of 3] md: Update md bitmap during resync.
