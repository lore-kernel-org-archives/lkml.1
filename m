Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYCAShM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYCAShM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 13:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYCASg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 13:36:56 -0500
Received: from brick.kernel.dk ([87.55.233.238]:18147 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757930AbYCASgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 13:36:49 -0500
Date: Sat, 1 Mar 2008 19:36:44 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] block/blk-tag.c should #include "blk.h"
Message-ID: <20080301183644.GC6704@kernel.dk>
References: <20080301161754.GE25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301161754.GE25835@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01 2008, Adrian Bunk wrote:
> Every file should include the headers containing the externs for its 
> global functions (in this case for __blk_queue_free_tags()).

Thanks Adrian, applied all of them.

-- 
Jens Axboe

