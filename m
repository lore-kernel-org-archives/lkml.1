Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506Ab0AKNhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0AKNhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 08:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077Ab0AKNhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 08:37:15 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34654 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0AKNhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 08:37:14 -0500
Date: Mon, 11 Jan 2010 14:37:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Jan Kara <jack@suse.cz>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/4] writeback: add missing kernel-doc notation
Message-ID: <20100111133712.GJ4489@kernel.dk>
References: <20100101203523.11a69c58.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100101203523.11a69c58.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 01 2010, Randy Dunlap wrote:
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Subject: writeback: add missing kernel-doc notation
> 
> Fix the following htmldocs warning:
> 
>   Warning(fs/fs-writeback.c:255): No description found for parameter 'sb'

Thanks, applied.

-- 
Jens Axboe

