Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXAWAW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXAWAW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 19:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932445AbXAWAW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 19:22:29 -0500
Received: from ns1.suse.de ([195.135.220.2]:35090 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541AbXAWAW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 19:22:28 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Tue, 23 Jan 2007 11:22:03 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 000 of 5] knfsd: Introduction - Assorted bugfixes
Message-ID: <20070123111558.27683.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following are 5 patches for kNFSd suitable for inclusion in 2.6.20.

A couple should go to 2.6.19-stable, but I'll send those separately.

NeilBrown


 [PATCH 001 of 5] knfsd: Update email address and status for NFSD in MAINTAINERS.
 [PATCH 002 of 5] knfsd: Fix setting of ACL server versions.
 [PATCH 003 of 5] knfsd: Fix an NFSD bug with full sized, non-page-aligned reads.
 [PATCH 004 of 5] knfsd: Replace some warning ins nfsfh.h with BUG_ON or WARN_ON
 [PATCH 005 of 5] knfsd: Don't mess with the 'mode' when storing a exclusive-create cookie.
