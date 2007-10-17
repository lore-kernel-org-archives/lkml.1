Return-Path: <linux-kernel-owner+w=401wt.eu-S1763704AbXJQIwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763704AbXJQIwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 04:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbXJQIwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 04:52:15 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11663 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbXJQIwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 04:52:14 -0400
Date: Wed, 17 Oct 2007 10:51:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-scsi@vger.kernel.org, tomof@acm.org
Subject: Re: [PATCH] IA64: iommu uses sg_next with an invalid sg element
Message-ID: <20071017085147.GJ5043@kernel.dk>
References: <20071017174927N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017174927N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, FUJITA Tomonori wrote:
> sg list elements might not be continuous.

Thanks, applied.

-- 
Jens Axboe

