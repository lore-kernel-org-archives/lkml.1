Return-Path: <linux-kernel-owner+w=401wt.eu-S1163314AbXD1R40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163314AbXD1R40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163313AbXD1R4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:56:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:1994 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163310AbXD1Rzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:55:55 -0400
Date: Sat, 28 Apr 2007 20:55:59 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Roland Dreier <rdreier@cisco.com>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: What's in infiniband.git for 2.6.22
Message-ID: <20070428175559.GC13106@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <adaps5rro8v.fsf@cisco.com> <20070427153016.GB1709@mellanox.co.il>
	<adaslalm9sd.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaslalm9sd.fsf@cisco.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Roland Dreier <rdreier@cisco.com>:
> Subject: Re: What's in infiniband.git for 2.6.22
> 
>  > What about the mthca patch to use separate HW queues for kernel RC/UD/userspace RC?
> 
> right, I'll queue that up too.
> BTW is there something analogous we could do for mlx4, or is FW not
> quite ready?

I am assured the issue this is sloving is not present in mlx4.

-- 
MST
