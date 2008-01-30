Return-Path: <linux-kernel-owner+w=401wt.eu-S932652AbYA3UTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbYA3UTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933195AbYA3UO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:14:56 -0500
Received: from brick.kernel.dk ([87.55.233.238]:9046 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933191AbYA3UOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:14:53 -0500
Date: Wed, 30 Jan 2008 21:14:49 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, axboe@kernek.dk,
       akpm <akpm@linux-foundation.org>,
       torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] docbook: fix block api fatal error
Message-ID: <20080130201448.GX15220@kernel.dk>
References: <20080130115100.91c43f97.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130115100.91c43f97.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30 2008, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix docbook fatal error:
> docproc: linux-2.6.24-git8/block/ll_rw_blk.c: No such file or directory

Thanks, applied.

-- 
Jens Axboe

