Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbYFPTVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbYFPTVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 15:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbYFPTVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 15:21:13 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8558 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186AbYFPTVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 15:21:10 -0400
Date: Mon, 16 Jun 2008 21:21:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1 of 3] block: Globalize bio_set and bio_vec_slab
Message-ID: <20080616192107.GW20851@kernel.dk>
References: <patchbomb.1213589417@sermon.lab.mkp.net> <24902abbf2b6fdb830f1.1213589418@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24902abbf2b6fdb830f1.1213589418@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16 2008, Martin K. Petersen wrote:
> Move struct bio_set and biovec_slab definitions to bio.h so they can
> be used outside of bio.c.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

I think I already acked this patch many months ago, obviously no
problems with this.

-- 
Jens Axboe

