Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbXJLNHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbXJLNHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbXJLNHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:07:22 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:57717 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068AbXJLNHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:07:19 -0400
X-IronPort-AV: E=Sophos;i="4.21,267,1188802800"; 
   d="scan'208";a="534340258"
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull infiniband.git for-linus
X-Message-Flag: Warning: May contain useful information
References: <aday7e9b0m3.fsf@cisco.com>
	<20071011.181719.78707713.davem@davemloft.net>
	<adatzoxax9p.fsf@cisco.com>
	<20071011.193634.48801952.davem@davemloft.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 12 Oct 2007 06:07:18 -0700
Message-ID: <adair5cbhx5.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Oct 2007 13:07:18.0468 (UTC) FILETIME=[D1533040:01C80CD0]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > I'm not sure what you mean.  During the 2.6.23 cycle I've been sending
 > > any patches that potentially could conflict with the net-2.6 tree to
 > > you and Jeff so that you can merge them upstream via your tree.  Or do
 > > you mean Jeff should become the maintainer of drivers/infiniband??
 > 
 > Not the maintainer, I'm just saying you should gateway
 > your patches through him.

What value do you see in that?  It just seems like it creates more
work for Jeff and gives no benefit over the current status quo.

 - R.
