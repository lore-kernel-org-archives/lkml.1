Return-Path: <linux-kernel-owner+w=401wt.eu-S1763671AbXGRKeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763671AbXGRKeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbXGRKeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:34:11 -0400
Received: from brick.kernel.dk ([80.160.20.94]:11995 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbXGRKeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:34:10 -0400
Date: Wed, 18 Jul 2007 12:33:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: crash with 2.6.21 BUG:ll_rw_blk.c
Message-ID: <20070718103342.GI11657@kernel.dk>
References: <469DD37C.8050200@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469DD37C.8050200@bfs.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18 2007, walter harms wrote:
> hi list,
> i managed to crash 2.6.21 at boottime with
> 
> IPI Shortcut mode
> BUG: atblock/ll_rw_blc.c 1566 blk_remove_plug()
> 
> 
> system: acer Notebook TM620
> 
> does anyone care or is 2.6.21 already done ?

We need a lot more than that, can you capture the full oops? Preferably
complete with boot messages prior to the oops.

-- 
Jens Axboe

