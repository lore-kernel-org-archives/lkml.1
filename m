Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbXLJFOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbXLJFOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 00:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbXLJFOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 00:14:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:43685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbXLJFOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 00:14:45 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 10 Dec 2007 16:14:40 +1100
Message-Id: <1071210051440.12083@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: [PATCH] knfsd: Change mailing list for nfsd in MAINTAINERS
References: <20071210161353.11987.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


nfs@lists.sourceforge.net is being decommissioned.

I wonder if the website should be changed to linux-nfs.org ...

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/MAINTAINERS ./MAINTAINERS
--- .prev/MAINTAINERS	2007-12-10 16:03:52.000000000 +1100
+++ ./MAINTAINERS	2007-12-10 16:04:07.000000000 +1100
@@ -2259,7 +2259,7 @@ P:	J. Bruce Fields
 M:	bfields@fieldses.org
 P:	Neil Brown
 M:	neilb@suse.de
-L:	nfs@lists.sourceforge.net
+L:	linux-nfs@vger.kernel.org
 W:	http://nfs.sourceforge.net/
 S:	Supported
 
