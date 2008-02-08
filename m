Return-Path: <linux-kernel-owner+w=401wt.eu-S933344AbYBHIwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344AbYBHIwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbYBHIvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:51:52 -0500
Received: from brick.kernel.dk ([87.55.233.238]:13780 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758181AbYBHIvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:51:51 -0500
Date: Fri, 8 Feb 2008 09:51:48 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "S, Chandrakala (STSD)" <chandrakala.s@hp.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       "Miller, Mike (OS Dev)" <mike.miller@hp.com>, grant.likely@secretlab.ca,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 0/7] blk_end_request: full I/O completion handler
Message-ID: <20080208085148.GD15220@kernel.dk>
References: <20080205103851.GQ15220@kernel.dk> <77334B9413C72244AE1B51ADD4868D700AFD9D60@BGEEXC02.asiapacific.cpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77334B9413C72244AE1B51ADD4868D700AFD9D60@BGEEXC02.asiapacific.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08 2008, S, Chandrakala (STSD) wrote:
> Hi,
> 
> Thanks for the information! 
> We would like to know when does the 2.6.25 kernel will be available at
> kernel.org.

So would I, if I locate my crystal ball I'll be sure to let you know :-)

Seriously, given past experience, it's probably sometime in April.

> 
> Thanks,
> Chandrakala 
> 
> -----Original Message-----
> From: Jens Axboe [mailto:jens.axboe@oracle.com] 
> Sent: Tuesday, February 05, 2008 4:09 PM
> To: S, Chandrakala (STSD)
> Cc: Kiyoshi Ueda; linux-kernel@vger.kernel.org;
> linux-scsi@vger.kernel.org; linux-ide@vger.kernel.org; Miller, Mike (OS
> Dev); grant.likely@secretlab.ca; dm-devel@redhat.com;
> j-nomura@ce.jp.nec.com
> Subject: Re: [PATCH 0/7] blk_end_request: full I/O completion handler
> 
> On Tue, Feb 05 2008, S, Chandrakala (STSD) wrote:
> > Hello,
> > 
> > We would like to know in which kernel version these patches are 
> > available.
> 
> They were merged after 2.6.24 was released, so they will show up in the
> 2.6.25 kernel.
> 
> --
> Jens Axboe
> 

-- 
Jens Axboe

