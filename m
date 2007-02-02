Return-Path: <linux-kernel-owner+w=401wt.eu-S1422962AbXBBEuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422962AbXBBEuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 23:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423009AbXBBEuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 23:50:52 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:9327 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422962AbXBBEuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 23:50:51 -0500
X-IronPort-AV: i="4.13,271,1167638400"; 
   d="scan'208"; a="108117627:sNHT43266294"
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000 of 14] knfsd: Preparation for IPv6 support in NFS server.
X-Message-Flag: Warning: May contain useful information
References: <20070202153531.18622.patches@notabene>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 01 Feb 2007 20:50:49 -0800
In-Reply-To: <20070202153531.18622.patches@notabene> (NeilBrown's message of "Fri, 2 Feb 2007 15:39:36 +1100")
Message-ID: <adahcu55fiu.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Feb 2007 04:50:49.0969 (UTC) FILETIME=[B5E5F610:01C74685]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > They are mostly from Chuck Level and make preparating for IPv6 support
 > in the NFS server.
 > They are *not* for 2.6.20, but should be ok for .21.

Out of curiousity, does this patch series reduce the delta between the
NFS/RDMA tree and mainline Linux?  In other words does this bring
NFS/RDMA closer to merging?

 - R.
