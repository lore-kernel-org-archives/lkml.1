Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbZHTWAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbZHTWAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 18:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZHTWAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 18:00:14 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:21375 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbZHTWAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 18:00:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAD9kjUqrR7O6/2dsb2JhbAC+bogvkQcFhBiENg
X-IronPort-AV: E=Sophos;i="4.43,416,1246838400"; 
   d="scan'208";a="371769798"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Opinions on moving Linux InfiniBand/RDMA mailing list to vger?
X-Message-Flag: Warning: May contain useful information
Date: Thu, 20 Aug 2009 15:00:14 -0700
Message-ID: <adavdkiw3gx.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Aug 2009 22:00:14.0755 (UTC) FILETIME=[98BFDF30:01CA21E1]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lately, I've had a few emails that I thought would have been of interest
to both lkml and also to general@lists.openfabrics.org.  I've held back
on cross-posting them because I know that general@ is subscribers-only,
and the bounce messages are quite annoying to replies coming from lkml.

The general@ list is subscribers-only because the openfabrics.org
sysadmin team is already overworked without trying to keep an open list
spam free.  (I say that with no intention to criticize the
openfabrics.org admins -- they do a terrific job of keeping things
running with the limited resources available; it's more a testament to
how impressive the vger mailing list admins are)

I've also noticed one or two messages about the possibility of moving
another moderated list to vger.  Certainly I prefer open lists that
don't require subscriptions to post.

So with that background, what would people think about creating an open
vger list (say, linux-rdma@vger.kernel.org) to carry the discussion
currently on general@lists.openfabrics.org?  (The transition plan would
probably be to keep the general@ list for a month or two, with frequent
announcements of the new list, until archives etc. have caught up with
the switch)

Thanks,
  Roland
