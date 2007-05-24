Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbXEXMrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbXEXMrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbXEXMrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:47:06 -0400
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:60532 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbXEXMrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:47:05 -0400
To: jens.axboe@oracle.com
Cc: James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp,
       pbadari@gmail.com, linux-kernel@vger.kernel.org, bhalevy@panasas.com,
       akpm@linux-foundation.org, michaelc@cs.wisc.edu
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20070524120554.GU5722@kernel.dk>
References: <20070524184334P.fujita.tomonori@lab.ntt.co.jp>
	<20070524100024.GR5722@kernel.dk>
	<20070524120554.GU5722@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070524214446V.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 24 May 2007 21:44:46 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
Date: Thu, 24 May 2007 14:05:54 +0200

> On Thu, May 24 2007, Jens Axboe wrote:
> > > http://git.kernel.org/?p=linux/kernel/git/tomo/linux-2.6-bidi.git;a=commitdiff;h=fb2747a9f2465ac4a1ea9e3533b92510fbcaae0c
> > 
> > Neat, will take a look! I should be able to just reuse that.
> 
> BTW, when do you plan on pushing the SCSI sg update? I'd love for it to
> be soon, so I can just rebase the sglist branch on that and get rid of
> the SCSI stuff in there.

Well, all I can say is that I'd love James to push the cleanups
patchset soon too.
