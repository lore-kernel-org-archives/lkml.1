Return-Path: <linux-kernel-owner+w=401wt.eu-S933290AbXHPQTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbXHPQTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763593AbXHPQTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:19:32 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:52286 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764448AbXHPQTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:19:31 -0400
X-IronPort-AV: i="4.19,272,1183359600"; 
   d="scan'208"; a="171240392:sNHT42396651"
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [GIT PULL] please pull infiniband.git for-linus branch
X-Message-Flag: Warning: May contain useful information
References: <adamyws2lry.fsf@cisco.com>
	<20070816064826.GB19432@mellanox.co.il>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 16 Aug 2007 09:19:26 -0700
In-Reply-To: <20070816064826.GB19432@mellanox.co.il> (Michael S. Tsirkin's message of "Thu, 16 Aug 2007 09:48:26 +0300")
Message-ID: <adaps1n1mgh.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Aug 2007 16:19:27.0511 (UTC) FILETIME=[379FCA70:01C7E021]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Hmm, if these things are appropriate for 2.6.23, maybe my patch
 > adding linux/mutex.h to ehca_classes.h can go in too?

Actually I queued Dotan's patches quite a while ago, although Linus
seems to be ignoring my pull requests.

I don't see any urgency in adding more similar patches to 2.6.23,
since AFAIK 2.6.23 builds fine, right?

Also I would prefer to get ehca patches from the ehca people at IBM,
or at least an ack from them.
