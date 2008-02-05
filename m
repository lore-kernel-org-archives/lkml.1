Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbYBEKj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbYBEKj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbYBEKi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:38:57 -0500
Received: from brick.kernel.dk ([87.55.233.238]:5936 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032AbYBEKiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:38:55 -0500
Date: Tue, 5 Feb 2008 11:38:52 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "S, Chandrakala (STSD)" <chandrakala.s@hp.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       "Miller, Mike (OS Dev)" <mike.miller@hp.com>, grant.likely@secretlab.ca,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 0/7] blk_end_request: full I/O completion handler
Message-ID: <20080205103851.GQ15220@kernel.dk>
References: <20070903074549.GJ4253@kernel.dk> <77334B9413C72244AE1B51ADD4868D700AF902CF@BGEEXC02.asiapacific.cpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77334B9413C72244AE1B51ADD4868D700AF902CF@BGEEXC02.asiapacific.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05 2008, S, Chandrakala (STSD) wrote:
> Hello,
> 
> We would like to know in which kernel version these patches are
> available.  

They were merged after 2.6.24 was released, so they will show up in the
2.6.25 kernel.

-- 
Jens Axboe

