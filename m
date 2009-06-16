Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZFPUNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZFPUNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbZFPUNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:13:47 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38933 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422AbZFPUNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:13:46 -0400
Date: Tue, 16 Jun 2009 22:13:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hd: stop defining MAJOR_NR
Message-ID: <20090616201348.GK11363@kernel.dk>
References: <20090616191750.GA22726@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616191750.GA22726@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16 2009, Christoph Hellwig wrote:
> Just use HD_MAJOR directly.

Thanks, applied.

-- 
Jens Axboe

