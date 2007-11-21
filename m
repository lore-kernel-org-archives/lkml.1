Return-Path: <linux-kernel-owner+w=401wt.eu-S1761399AbXKULaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761399AbXKULaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 06:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbXKUL36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 06:29:58 -0500
Received: from brick.kernel.dk ([87.55.233.238]:10466 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587AbXKUL35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 06:29:57 -0500
Date: Wed, 21 Nov 2007 12:26:55 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: kill deprecated virt_to_bus
Message-ID: <20071121112655.GI6956@kernel.dk>
References: <20071120000238O.tomof@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120000238O.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20 2007, FUJITA Tomonori wrote:
> pci-noop.c doesn't use DMA mappings.

you should send that one to the alpha maintainers, it needs to go in
that way.

-- 
Jens Axboe

