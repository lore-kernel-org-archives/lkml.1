Return-Path: <linux-kernel-owner+w=401wt.eu-S1761352AbXGPUdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352AbXGPUdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbXGPUdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:33:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:39366 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbXGPUdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:33:02 -0400
Date: Mon, 16 Jul 2007 23:05:40 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Roland Dreier <rdreier@cisco.com>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: Further 2.6.23 merge plans...
Message-ID: <20070716200540.GA8527@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <adalkdl43w0.fsf@cisco.com> <adahco943ip.fsf@cisco.com>
	<20070713054711.GA21709@mellanox.co.il> <adar6nc2mt4.fsf@cisco.com>
	<20070714175425.GA17597@mellanox.co.il> <adabqecxpte.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adabqecxpte.fsf@cisco.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Roland Dreier <rdreier@cisco.com>:
> Subject: Re: Further 2.6.23 merge plans...
> 
>  > > I haven't done any work on it or seen anything from anyone else, so I
>  > > expect this will have to wait for 2.6.24.
> 
>  > I'm surprised to hear this. How about this:
>  > http://lists.openfabrics.org/pipermail/general/2007-May/035757.html
> 
> Sure, I remember that.  But I haven't seen anything to suggest that
> anyone has given any further thought to the issues that were raised in
> that thread.

Well, the only issue I recall is about the # of EQs we want to allocate.
Was there something else?

Maybe code can be merged as-is (2 EQs) and the number be tuned
later as applications start using vectors?

-- 
MST
