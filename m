Return-Path: <linux-kernel-owner+w=401wt.eu-S1761080AbXIRRXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080AbXIRRXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760187AbXIRRXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:23:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:23341 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759633AbXIRRXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:23:01 -0400
Date: Tue, 18 Sep 2007 19:22:39 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Roland Dreier <rdreier@cisco.com>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.24
Message-ID: <20070918172239.GA23320@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <adahclymos8.fsf@cisco.com> <20070918163433.GL2050@mellanox.co.il>
	<adafy1blwok.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adafy1blwok.fsf@cisco.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Roland Dreier <rdreier@cisco.com>:
> Subject: Re: InfiniBand/RDMA merge plans for 2.6.24
> 
>  > Roland, could you merge the common TX CQ patch please?
>  > It actually fixes a real problem.
> 
> Yes, I will, but it collides with the net-2.6.24 NAPI rework I think,
> so it may not go in until a few days after the merge window.
> 
> Have you verified that the patch cures the interrupt overload issues?

Yes.

-- 
MST
