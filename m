Return-Path: <linux-kernel-owner+w=401wt.eu-S1762178AbZCZXsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762178AbZCZXsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbZCZXsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:48:43 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:28330 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbZCZXsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:48:42 -0400
X-IronPort-AV: E=Sophos;i="4.38,429,1233532800"; 
   d="scan'208";a="274977238"
From: Roland Dreier <rdreier@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: RDMA/nes: Fix mis-merge
References: <20090326.152515.43533230.davem@davemloft.net>
	<alpine.LFD.2.00.0903261555290.3032@localhost.localdomain>
	<adahc1fuarm.fsf_-_@cisco.com>
	<20090326.163114.131582923.davem@davemloft.net>
	<alpine.LFD.2.00.0903261638360.3994@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 26 Mar 2009 16:48:39 -0700
In-Reply-To: <alpine.LFD.2.00.0903261638360.3994@localhost.localdomain> (Linus
	Torvalds's message of "Thu, 26 Mar 2009 16:38:52 -0700 (PDT)")
Message-ID: <adad4c3u9pk.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Mar 2009 23:48:39.0868 (UTC) FILETIME=[636017C0:01C9AE6D]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Can I get a sign-off from Roland too?

Duh, not my day...

Signed-off-by: Roland Dreier <rolandd@cisco.com>
