Return-Path: <linux-kernel-owner+w=401wt.eu-S932551AbZJLPHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551AbZJLPHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932217AbZJLPHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:07:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59992 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385AbZJLPHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:07:50 -0400
Date: Mon, 12 Oct 2009 17:07:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blkdev: flush disk cache on ->fsync
Message-ID: <20091012150713.GM9228@kernel.dk>
References: <20090820182432.GA31520@lst.de> <20091010161531.GA30289@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091010161531.GA30289@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10 2009, Christoph Hellwig wrote:
> Is anyone going to pick up this patch?

I can pick it up for .33. I think it looks good, but it's probably
something we should add up front.

-- 
Jens Axboe

