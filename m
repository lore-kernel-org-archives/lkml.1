Return-Path: <linux-kernel-owner+w=401wt.eu-S1764317AbXHYGDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764317AbXHYGDY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 02:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758733AbXHYGDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 02:03:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54000
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756246AbXHYGDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 02:03:12 -0400
Date: Fri, 24 Aug 2007 23:03:09 -0700 (PDT)
Message-Id: <20070824.230309.21227596.davem@davemloft.net>
To: shannon.nelson@intel.com
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
       jgarzik@pobox.com
Subject: Re: [PATCH] IOAT: ioatdma needs to to play nice in a
 multi-dma-client world
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070823001218.11648.49528.stgit@localhost.localdomain>
References: <20070823001218.11648.49528.stgit@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shannon Nelson <shannon.nelson@intel.com>
Date: Wed, 22 Aug 2007 17:12:18 -0700

> Now that the DMA engine has a multi-client interface, fix the ioatdma
> driver to play along.  At the same time, remove a couple of unnecessary
> reads and writes.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>

Applied, thanks Shannon.
