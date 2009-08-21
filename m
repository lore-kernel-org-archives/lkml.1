Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZHUJKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZHUJKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 05:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbZHUJKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 05:10:05 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:59579 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbZHUJKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 05:10:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEcBjkqrR7PD/2dsb2JhbAC9aIgvkQUFhBiENg
X-IronPort-AV: E=Sophos;i="4.44,249,1249257600"; 
   d="scan'208";a="90911613"
From: Roland Dreier <rdreier@cisco.com>
To: "Woodruff\, Robert J" <robert.j.woodruff@intel.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "general\@lists.openfabrics.org" <general@lists.openfabrics.org>
Subject: Re: [ofa-general] Opinions on moving Linux InfiniBand/RDMA mailing list	to vger?
References: <adavdkiw3gx.fsf@cisco.com>
	<382A478CAD40FA4FB46605CF81FE39F43A52A9BF@orsmsx507.amr.corp.intel.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 21 Aug 2009 02:10:04 -0700
In-Reply-To: <382A478CAD40FA4FB46605CF81FE39F43A52A9BF@orsmsx507.amr.corp.intel.com>
	(Robert J. Woodruff's message of "Thu, 20 Aug 2009 15:41:39 -0700")
Message-ID: <adaiqghwn0z.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Aug 2009 09:10:04.0691 (UTC) FILETIME=[2BD16E30:01CA223F]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > The one question I would have would be do the kernel.org people want to
 > see all of the traffic that we currently have on the open fabrics 
 > general list for all of the user-space components? 

I don't believe there's any problem with that.  vger already hosts quite
a few lists that are userspace only (eg git) or span user and kernel (eg
alsa and kvm).  And in any case the total traffic (# of subscribers, #
of messages) that the current general@ list generates is pretty minimal
compared to what vger already handles, so I think there's no problem
with having a linux-rdma@vger.kernel.org carry everything that
general@lists.openfabrics.org does today.

 - R.
