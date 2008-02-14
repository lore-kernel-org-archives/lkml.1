Return-Path: <linux-kernel-owner+w=401wt.eu-S1764098AbYBNXXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764098AbYBNXXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757044AbYBNXWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:22:50 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:6736 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458AbYBNXWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:22:48 -0500
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
X-Message-Flag: Warning: May contain useful information
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 14 Feb 2008 15:22:46 -0800
In-Reply-To: <20080212120208.f7168a91.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Tue, 12 Feb 2008 12:02:08 +1100")
Message-ID: <adalk5np1h5.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Feb 2008 23:22:46.0726 (UTC) FILETIME=[81EAEE60:01C86F60]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The first things I need from the subsystem maintainers (you know who you
 > are) are a contact address (a list address is fine) and at least one git
 > branch or quilt series that contains all the things you want to see go
 > into 2.6.26.

For InfiniBand/RDMA, the tree is:

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-next

or via git protocol:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-next

contact addresses (me plus a mailing list):

    rolandd@cisco.com
    general@lists.openfabrics.org

thanks!
