Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbYKXJks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbYKXJks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYKXJkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:40:40 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:58446 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbYKXJkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:40:39 -0500
Date: Mon, 24 Nov 2008 10:38:42 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] block/blk-tag.c: cleanup kernel-doc
Message-ID: <20081124093841.GB26308@kernel.dk>
References: <492a6f43.054c6e0a.7df6.368b@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492a6f43.054c6e0a.7df6.368b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24 2008, Qinghuang Feng wrote:
> There is no argument named @tags in blk_init_tags,
> remove its' comment.

Thanks, applied.

-- 
Jens Axboe

