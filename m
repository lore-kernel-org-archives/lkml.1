Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbYBZGtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbYBZGtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 01:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYBZGtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 01:49:16 -0500
Received: from relay2.sgi.com ([192.48.171.30]:48476 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750907AbYBZGtP (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 01:49:15 -0500
Date: Tue, 26 Feb 2008 17:49:09 +1100
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.25-rc4
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080226064909.5457F58C4C0F@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/xfs_bit.c     |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bit.h     |   27 ++-----------
 fs/xfs/xfs_rtalloc.c |   19 ++++++---
 3 files changed, 120 insertions(+), 29 deletions(-)

through these commits:

commit ef8ece55d9b6825c28a5c1a4bd89b94040cb7b32
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Tue Feb 26 17:00:22 2008 +1100

    [XFS] Undo bit ops cleanup mod due to regression on 32-bit powermac
    platform.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30559a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit db69c915e67705daac25cad06d816c09be634de0
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Tue Feb 26 17:00:14 2008 +1100

    [XFS] Undo bit ops cleanup mod due to regression on 32-bit powermac
    platform.
    
    SGI-PV: 974005
    SGI-Modid: xfs-linux-melb:xfs-kern:30558a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
