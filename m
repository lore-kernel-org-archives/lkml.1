Return-Path: <linux-kernel-owner+w=401wt.eu-S934510AbXHGNdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934510AbXHGNdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761594AbXHGNc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:32:57 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17445 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313AbXHGNc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:32:56 -0400
Date: Tue, 7 Aug 2007 15:32:52 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: btrace <linux-btrace@vger.kernel.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix remap handling by blktrace
Message-ID: <20070807133252.GY5245@kernel.dk>
References: <46B87357.8040802@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B87357.8040802@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07 2007, Alan D. Brunelle wrote:
> 

> 
> This patch provides more information concerning REMAP operations on block
> IOs. The additional information provides clearer details at the user level,
> and supports post-processing analysis in btt.
> 
> o  Adds in partition remaps on the same device.
> o  Fixed up the remap information in DM to be in the right order
> o  Sent up mapped-from and mapped-to device information
> 
> Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>

Thanks (again) Alan, applied!

-- 
Jens Axboe

