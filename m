Return-Path: <linux-kernel-owner+w=401wt.eu-S932653AbXBESUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbXBESUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932663AbXBESUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:20:54 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:53104 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932653AbXBESUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:20:53 -0500
Date: Mon, 5 Feb 2007 10:20:40 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Andrew Morton <akpm@osdl.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
In-Reply-To: <20070205125643.GG4487@kernel.dk>
Message-ID: <Pine.LNX.4.64.0702051019340.6772@schroedinger.engr.sgi.com>
References: <20070131163638.290f40c1.akpm@osdl.org> <20070201062018.GC33919298@melbourne.sgi.com>
 <20070131231253.fdebc9f5.akpm@osdl.org> <Pine.LNX.4.64.0702011055310.7010@schroedinger.engr.sgi.com>
 <20070201191857.GQ10305@kernel.dk> <Pine.LNX.4.64.0702011214230.10061@schroedinger.engr.sgi.com>
 <20070201202646.GR10305@kernel.dk> <Pine.LNX.4.64.0702011435060.4632@schroedinger.engr.sgi.com>
 <20070205120253.GC4487@kernel.dk> <20070205121735.GD4487@kernel.dk>
 <20070205125643.GG4487@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, Jens Axboe wrote:

> But for now this is just a debug test, can you see if xfs with barriers
> for that kernel now works as expected?

The kernel that failed before boots fine with this patch.

