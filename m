Return-Path: <linux-kernel-owner+w=401wt.eu-S935363AbXJPT7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935363AbXJPT7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965080AbXJPT7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:59:25 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8939 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964813AbXJPT7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:59:24 -0400
Date: Tue, 16 Oct 2007 21:59:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Anton Blanchard <anton@samba.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix powerpc breakage in sg chaining code
Message-ID: <20071016195916.GF9942@kernel.dk>
References: <20071016195433.GA15297@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016195433.GA15297@kryten>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16 2007, Anton Blanchard wrote:
> 
> Commit 78bdc3106a877cfa50439fa66b52acbc4e7868df PPC: sg chaining support
> looks to have removed some unrelated ppc code.

Woops, how on earth did that happen?! Must have been a bad git fixup.

> Lets put it back in.

I agree :-)

-- 
Jens Axboe

