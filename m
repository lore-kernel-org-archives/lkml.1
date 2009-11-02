Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZKBKq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZKBKq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbZKBKq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:46:57 -0500
Received: from [95.166.99.235] ([95.166.99.235]:41524 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbZKBKq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:46:56 -0500
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Nov 2009 05:46:56 EST
Date: Mon, 2 Nov 2009 11:38:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tj@kernel.org
Subject: Re: [PATCH] Fix bio_alloc() and bio_kmalloc() documentation
Message-ID: <20091102103850.GM10727@kernel.dk>
References: <1257031116-17934-1-git-send-email-albertito@blitiri.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257031116-17934-1-git-send-email-albertito@blitiri.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 31 2009, Alberto Bertogli wrote:
> Commit 451a9ebf accidentally broke bio_alloc() and bio_kmalloc() comments by
> (almost) swapping them.
> 
> This patch fixes that, by placing the comments in the right place.

Thanks, applied to for-linus.

-- 
Jens Axboe

