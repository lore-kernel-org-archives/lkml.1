Return-Path: <linux-kernel-owner+w=401wt.eu-S933136AbXBESc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136AbXBESc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933231AbXBESc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:32:28 -0500
Received: from brick.kernel.dk ([62.242.22.158]:10329 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933169AbXBEScM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:32:12 -0500
Date: Mon, 5 Feb 2007 19:34:38 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070205183438.GL4487@kernel.dk>
References: <20070131231253.fdebc9f5.akpm@osdl.org> <Pine.LNX.4.64.0702011055310.7010@schroedinger.engr.sgi.com> <20070201191857.GQ10305@kernel.dk> <Pine.LNX.4.64.0702011214230.10061@schroedinger.engr.sgi.com> <20070201202646.GR10305@kernel.dk> <Pine.LNX.4.64.0702011435060.4632@schroedinger.engr.sgi.com> <20070205120253.GC4487@kernel.dk> <20070205121735.GD4487@kernel.dk> <20070205125643.GG4487@kernel.dk> <Pine.LNX.4.64.0702051019340.6772@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702051019340.6772@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05 2007, Christoph Lameter wrote:
> On Mon, 5 Feb 2007, Jens Axboe wrote:
> 
> > But for now this is just a debug test, can you see if xfs with barriers
> > for that kernel now works as expected?
> 
> The kernel that failed before boots fine with this patch.

Wonderful, I'll leave the patch in-place for now.

-- 
Jens Axboe

