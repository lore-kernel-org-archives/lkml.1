Return-Path: <linux-kernel-owner+w=401wt.eu-S940297AbXHMSMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940297AbXHMSMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S974190AbXHMR6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:58:20 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17762 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295AbXHMR6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:58:17 -0400
Date: Mon, 13 Aug 2007 19:58:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [418/2many] MAINTAINERS - SCSI CDROM DRIVER
Message-ID: <20070813175812.GX23758@kernel.dk>
References: <46bffba3.92NZRByJnVYnqXQs%joe@perches.com> <20070813103254.GO23758@kernel.dk> <1187027602.10249.180.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187027602.10249.180.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13 2007, Joe Perches wrote:
> On Mon, 2007-08-13 at 12:32 +0200, Jens Axboe wrote:
> > > +F:	drivers/scsi/sr.*
> > Not correct, it should be sr*
> 
> SCSI CDROM DRIVER
> P:	Jens Axboe
> M:	axboe@kernel.dk
> L:	linux-scsi@vger.kernel.org
> W:	http://www.kernel.dk
> S:	Maintained
> F:	drivers/scsi/sr*

That looks better.

-- 
Jens Axboe

