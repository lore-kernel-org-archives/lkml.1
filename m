Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbXFUEam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbXFUEam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 00:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbXFUEaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 00:30:35 -0400
Received: from mail.suse.de ([195.135.220.2]:41684 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbXFUEaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 00:30:35 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2007 14:30:17 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Alexander Soule <soule@umich.edu>
Cc: Benny Halevy <bhalevy@panasas.com>
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 000 of 8] knfsd: Assorted nfsv4 server patches.
Message-ID: <20070621142604.727.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following 8 patches fix minor bug and provide minor enhancements for
nfsv4 service.  They all have "no obvious style problems" and are
"ready for submission".

They are appropriate for inclusion in 2.6.23-rc1.
They are against 2.6.22-rc4-mm2.

Thanks,
NeilBrown


 [PATCH 001 of 8] knfsd: lockd: nfsd4: use same grace period for lockd and nfsd4
 [PATCH 002 of 8] knfsd: nfsd4: fix NFSv4 filehandle size units confusion
 [PATCH 003 of 8] knfsd: nfsd4: silence a compiler warning in ACL code
 [PATCH 004 of 8] knfsd: nfsd4: fix enc_stateid_sz for nfsd callbacks
 [PATCH 005 of 8] knfsd: nfsd4: fix handling of acl errrors
 [PATCH 006 of 8] knfsd: nfsd: remove unused header interface.h
 [PATCH 007 of 8] knfsd: nfsd4: vary maximum delegation limit based on RAM size
 [PATCH 008 of 8] knfsd: nfsd4: don't delegate files that have had conflicts
