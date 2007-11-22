Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbXKVCti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbXKVCti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 21:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXKVCt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 21:49:28 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47789 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbXKVCt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 21:49:27 -0500
Date: Thu, 22 Nov 2007 11:49:10 +0900
To: jens.axboe@oracle.com
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: kill deprecated virt_to_bus
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <20071121112655.GI6956@kernel.dk>
References: <20071120000238O.tomof@acm.org>
	<20071121112655.GI6956@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071122115209W.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 12:26:55 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Nov 20 2007, FUJITA Tomonori wrote:
> > pci-noop.c doesn't use DMA mappings.
> 
> you should send that one to the alpha maintainers, it needs to go in
> that way.

Yeah, I'll do.
