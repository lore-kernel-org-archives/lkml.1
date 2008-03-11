Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbYCKGMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbYCKGMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 02:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYCKGLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 02:11:53 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5112 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYCKGLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 02:11:52 -0400
Date: Tue, 11 Mar 2008 07:11:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block/blk-merge.c: inverted likeliness in ll_back_merge_fn()
Message-ID: <20080311061148.GC17940@kernel.dk>
References: <47D5E1ED.3020804@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D5E1ED.3020804@tiscali.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11 2008, Roel Kluin wrote:
> In my likely profile it appears this one is inverted.

Depends entirely on the workload, it should be removed rather than
inverted.

-- 
Jens Axboe

