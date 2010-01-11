Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525Ab0AKNhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab0AKNhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 08:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358Ab0AKNhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 08:37:55 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34669 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab0AKNhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 08:37:54 -0500
Date: Mon, 11 Jan 2010 14:37:53 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Jan Kara <jack@suse.cz>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/4] writeback: add missing kernel-doc notation
Message-ID: <20100111133753.GK4489@kernel.dk>
References: <20100101203523.11a69c58.randy.dunlap@oracle.com> <20100111133712.GJ4489@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100111133712.GJ4489@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11 2010, Jens Axboe wrote:
> On Fri, Jan 01 2010, Randy Dunlap wrote:
> > From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > Subject: writeback: add missing kernel-doc notation
> > 
> > Fix the following htmldocs warning:
> > 
> >   Warning(fs/fs-writeback.c:255): No description found for parameter 'sb'
> 
> Thanks, applied.

and found out it was already included, my for-linus hasn't caught up
yet. So ignore this noise.

-- 
Jens Axboe

