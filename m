Return-Path: <linux-kernel-owner+w=401wt.eu-S1760372AbZC0WQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372AbZC0WQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZC0WP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:15:58 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:6516 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbZC0WP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:15:56 -0400
X-IronPort-AV: E=Sophos;i="4.38,435,1233532800"; 
   d="scan'208";a="275586467"
From: Roland Dreier <rdreier@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RDMA/nes: Fix mis-merge
References: <20090326.020714.36421849.davem@davemloft.net>
	<20090326.152515.43533230.davem@davemloft.net>
	<alpine.LFD.2.00.0903261555290.3032@localhost.localdomain>
	<adahc1fuarm.fsf_-_@cisco.com> <ada4oxeu67q.fsf_-_@cisco.com>
	<alpine.LFD.2.00.0903271440400.3994@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 27 Mar 2009 15:15:54 -0700
In-Reply-To: <alpine.LFD.2.00.0903271440400.3994@localhost.localdomain> (Linus
	Torvalds's message of "Fri, 27 Mar 2009 14:41:24 -0700 (PDT)")
Message-ID: <aday6uqtxwl.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Mar 2009 22:15:54.0841 (UTC) FILETIME=[98C61C90:01C9AF29]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Actually, it didn't get dropped - I just forgot to push out my tree after 
 > the final fixes yesterday.

OK -- tree looks good now, thanks.
