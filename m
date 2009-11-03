Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbZKCSfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbZKCSfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbZKCSfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:35:23 -0500
Received: from [95.166.99.235] ([95.166.99.235]:44450 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbZKCSfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:35:23 -0500
Date: Tue, 3 Nov 2009 19:35:27 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, jack@suse.cz,
       chris.mason@oracle.com
Subject: Re: writeback tracing
Message-ID: <20091103183527.GE8742@kernel.dk>
References: <20091029085501.GA10727@kernel.dk> <20091103141159.GA13442@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103141159.GA13442@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03 2009, Wu Fengguang wrote:
> Hi Jens,
> 
> Thanks, it's a very good step. I'll take advantage of it for writeback
> testing/debugging and watch how things work :)

Yep, it's interesting :-)

> However you didn't plan to submit it soon?  Because tracepoints are
> expected to be relatively stable, and you know that writeback is
> somehow a hot topic now, hehe.

No, I don't have submission plans yet. Just wanted to throw this out
there and see if we can agree on some decent trace points for a
potential future submission. But so far I just wanted to play around and
have others do the same.

-- 
Jens Axboe

