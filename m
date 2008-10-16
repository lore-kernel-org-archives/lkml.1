Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbYJPFrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbYJPFrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 01:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYJPFrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 01:47:06 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41949 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbYJPFrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 01:47:04 -0400
Date: Thu, 16 Oct 2008 07:46:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix current kernel-doc warnings
Message-ID: <20081016054618.GO19428@kernel.dk>
References: <48F4D100.5080400@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F4D100.5080400@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14 2008, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix block kernel-doc warnings:
> 
> Warning(linux-2.6.27-git4//fs/block_dev.c:1272): No description found for parameter 'path'
> Warning(linux-2.6.27-git4//block/blk-core.c:1021): No description found for parameter 'cpu'
> Warning(linux-2.6.27-git4//block/blk-core.c:1021): No description found for parameter 'part'
> Warning(/var/linsrc/linux-2.6.27-git4//block/genhd.c:544): No description found for parameter 'partno'

Applied, thanks

-- 
Jens Axboe

