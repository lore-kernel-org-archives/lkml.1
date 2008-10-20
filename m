Return-Path: <linux-kernel-owner+w=401wt.eu-S1751694AbYJTFgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbYJTFgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 01:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYJTFgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 01:36:42 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45728 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYJTFgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 01:36:41 -0400
Date: Mon, 20 Oct 2008 07:35:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: remove unused ll_new_mergeable()
Message-ID: <20081020053547.GY19428@kernel.dk>
References: <20081011153521M.fujita.tomonori@lab.ntt.co.jp> <20081020141141L.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020141141L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20 2008, FUJITA Tomonori wrote:
> On Sat, 11 Oct 2008 15:38:08 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > This is against the latest git (b922df7383749a1c0b7ea64c50fa839263d3816b).
> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] block: remove unused ll_new_mergeable()
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  block/blk-merge.c |   21 ---------------------
> >  1 files changed, 0 insertions(+), 21 deletions(-)
> 
> Ping. Any reason to keep this function?

Not at all, I thought I had already merged this up - woops! Applied,
thanks.

-- 
Jens Axboe

