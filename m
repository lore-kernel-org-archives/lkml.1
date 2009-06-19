Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbZFSHSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbZFSHSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbZFSHSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:18:12 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42334 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbZFSHSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:18:11 -0400
Date: Fri, 19 Jun 2009 09:18:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix blk-settings kernel-doc warning
Message-ID: <20090619071813.GH11363@kernel.dk>
References: <4A3AFA06.1000107@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3AFA06.1000107@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18 2009, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kernel-doc parameter name typo in blk-settings.c:
> 
> Warning(block/blk-settings.c:108): No description found for parameter 'lim'
> Warning(block/blk-settings.c:108): Excess function parameter 'limits' description in 'blk_set_default_limits'

Thanks Randy, applied.

-- 
Jens Axboe

