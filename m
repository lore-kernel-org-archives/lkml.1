Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbXEXMHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbXEXMHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbXEXMHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:07:19 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26859 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbXEXMHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:07:18 -0400
Date: Thu, 24 May 2007 14:05:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: pbadari@gmail.com, linux-kernel@vger.kernel.org, bhalevy@panasas.com,
       akpm@linux-foundation.org, michaelc@cs.wisc.edu
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
Message-ID: <20070524120554.GU5722@kernel.dk>
References: <20070521063554.GF14746@kernel.dk> <1179872108.29302.55.camel@dyn9047017100.beaverton.ibm.com> <20070524093441.GP5722@kernel.dk> <20070524184334P.fujita.tomonori@lab.ntt.co.jp> <20070524100024.GR5722@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524100024.GR5722@kernel.dk>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24 2007, Jens Axboe wrote:
> > http://git.kernel.org/?p=linux/kernel/git/tomo/linux-2.6-bidi.git;a=commitdiff;h=fb2747a9f2465ac4a1ea9e3533b92510fbcaae0c
> 
> Neat, will take a look! I should be able to just reuse that.

BTW, when do you plan on pushing the SCSI sg update? I'd love for it to
be soon, so I can just rebase the sglist branch on that and get rid of
the SCSI stuff in there.

-- 
Jens Axboe

