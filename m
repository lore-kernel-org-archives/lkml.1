Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbYIRQfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbYIRQfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbYIRQfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:35:13 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:59887 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbYIRQfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:35:12 -0400
Date: Thu, 18 Sep 2008 18:35:08 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH] fix an example of scatterlists handling in DMA-API.txt
Message-ID: <20080918163508.GM20055@kernel.dk>
References: <20080919012902J.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919012902J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19 2008, FUJITA Tomonori wrote:
> This example isn't the proper way to handle scatterlists (can't handle
> sg chaining).

Woops, good catch. Applied.

-- 
Jens Axboe

