Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343Ab0AYKGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab0AYKGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 05:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305Ab0AYKGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 05:06:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54341
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291Ab0AYKGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 05:06:54 -0500
Date: Mon, 25 Jan 2010 02:07:06 -0800 (PST)
Message-Id: <20100125.020706.91413669.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: akpm@linux-foundation.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: remove deprecated function descriptions
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100125174423M.fujita.tomonori@lab.ntt.co.jp>
References: <20100125174423M.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 25 Jan 2010 17:46:14 +0900

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] Documentation: remove deprecated function descriptions
> 
> dma_sync_single, pci_dma_sync_single, dma_sync_sg, and pci_dma_sync_sg
> are deprecated. We should not advertise them.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: David S. Miller <davem@davemloft.net>
