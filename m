Return-Path: <linux-kernel-owner+w=401wt.eu-S934240AbXCWAqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240AbXCWAqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 20:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934246AbXCWAqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 20:46:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934245AbXCWAqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 20:46:49 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 23 Mar 2007 11:46:43 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 000 of 4] knfsd: 4 bugfixes for nfsd suitable for 2.6.21
Message-ID: <20070323114512.28822.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following are 4 small bugfixes for nfsd that are suitable for 2.6.21.

Thanks,
NeilBrown

 [PATCH 001 of 4] knfsd: Allow nfsd READDIR to return 64bit cookies
 [PATCH 002 of 4] knfsd: nfsd4: fix inheritance flags on v4 ace derived from posix default ace
 [PATCH 003 of 4] knfsd: nfsd4: demote "clientid in use" printk to a dprintk
 [PATCH 004 of 4] knfsd: nfsd4: remove superfluous cancel_delayed_work() call
