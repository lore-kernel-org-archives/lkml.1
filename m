Return-Path: <linux-kernel-owner+w=401wt.eu-S1752017Ab0AYHDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab0AYHDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 02:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823Ab0AYHDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 02:03:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41555
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816Ab0AYHDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 02:03:47 -0500
Date: Sun, 24 Jan 2010 23:03:59 -0800 (PST)
Message-Id: <20100124.230359.155419105.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] frv: remove pci_dma_sync_signle and pci_dma_sync_sg
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100125155943G.fujita.tomonori@lab.ntt.co.jp>
References: <20100125155943G.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 25 Jan 2010 16:01:02 +0900

> No architecture except for frv has pci_dma_sync_signle() and
> pci_dma_sync_sg(). The APIs are deprecated.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: David S. Miller <davem@davemloft.net>
