Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYHDI61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYHDI61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 04:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbYHDI6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 04:58:18 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5486 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbYHDI6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 04:58:16 -0400
Date: Mon, 4 Aug 2008 10:58:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>,
       ISS StorageDev <iss_storagedev@hp.com>
Subject: Re: [PATCH] cciss: return -EFAULT if copy_from_user() fails
Message-ID: <20080804085814.GZ20055@kernel.dk>
References: <200807311135.48889.knikanth@suse.de> <0F5B06BAB751E047AB5C87D1F77A778826B3E814F0@GVW0547EXC.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778826B3E814F0@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31 2008, Miller, Mike (OS Dev) wrote:
> 
> 
> > -----Original Message-----
> > From: Nikanth Karthikesan [mailto:knikanth@suse.de]
> > Sent: Thursday, July 31, 2008 1:06 AM
> > To: Miller, Mike (OS Dev)
> > Cc: ISS StorageDev; Jens Axboe
> > Subject: [PATCH] cciss: return -EFAULT if copy_from_user() fails
> >
> > Return -EFAULT instead of -ENOMEM if copy_from_user() fails.
> >
> > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> Acked-by: Mike Miller <mike.miller@hp.com>

Applied

-- 
Jens Axboe

