Return-Path: <linux-kernel-owner+w=401wt.eu-S1765778AbZFQMTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765778AbZFQMTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756932AbZFQMSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:18:54 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34567 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308AbZFQMSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:18:53 -0400
Date: Wed, 17 Jun 2009 14:18:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: 2.6.30 backport (Was "Re: [PATCH 0/10] Per-bdi writeback flusher
	threads v11")
Message-ID: <20090617121855.GB11363@kernel.dk>
References: <1245236842-3141-1-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245236842-3141-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17 2009, Jens Axboe wrote:
> For ease of patching, I've put the full diff here:
> 
>   http://kernel.dk/writeback-v11.patch

On popular demand [1], I've added a backport for 2.6.30 as well. Should
be identical to the three prep patches from v10 + the core code from
v11.

Find it here:

   http://kernel.dk/writeback-v11-2.6.30.patch

[1] OK one person asked explicitly and another voiced interest, that's
    popular in my book :-)

-- 
Jens Axboe

