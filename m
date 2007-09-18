Return-Path: <linux-kernel-owner+w=401wt.eu-S1759838AbXIRQfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838AbXIRQfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759435AbXIRQe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:34:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:16913 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333AbXIRQe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:34:56 -0400
Date: Tue, 18 Sep 2007 18:34:33 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Roland Dreier <rdreier@cisco.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.24
Message-ID: <20070918163433.GL2050@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <adahclymos8.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adahclymos8.fsf@cisco.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Roland Dreier <rdreier@cisco.com>:
> Subject: InfiniBand/RDMA merge plans for 2.6.24
> 
> With 2.6.24 probably opening in the not-too-distant future, it's
> probably a good time to review what my plans are for when the merge
> window opens.

Roland, could you merge the common TX CQ patch please?
It actually fixes a real problem.


-- 
MST
