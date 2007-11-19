Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbXKSPSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbXKSPSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbXKSPSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:18:06 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50484 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbXKSPSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:18:05 -0500
Date: Tue, 20 Nov 2007 00:05:25 +0900
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: fix sg_page breakage
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <20071120000231O.tomof@acm.org>
References: <20071120000231O.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071120000802B.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 00:00:41 +0900
FUJITA Tomonori <tomof@acm.org> wrote:

> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/alpha/kernel/pci-noop.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/alpha/kernel/pci-noop.c b/arch/alpha/kernel/pci-noop.c

Oops, this should have been [PATCH 1/2] and 'kill deprecated
virt_to_bus' should have been [PATCH 2/2].

Thanks,
