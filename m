Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbXD2HvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbXD2HvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbXD2HvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:51:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:25364 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbXD2HvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:51:11 -0400
Date: Sun, 29 Apr 2007 10:51:12 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Roland Dreier <rdreier@cisco.com>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: What's in infiniband.git for 2.6.22
Message-ID: <20070429075112.GA7869@mellanox.co.il>
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

I think you want to queue the following obvios bugix up as well:
http://www.openfabrics.org/git/?p=~vlad/ofed_1_2/.git;a=blob;f=kernel_patches/fixes/ipoib_crash_on_error.patch;hb=HEAD

-- 
MST
