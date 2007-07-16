Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbXGPL3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbXGPL3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbXGPL3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:29:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51498
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753420AbXGPL3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:29:11 -0400
Date: Mon, 16 Jul 2007 04:29:13 -0700 (PDT)
Message-Id: <20070716.042913.45178602.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 13/33] SPARC: sg chaining support
From: David Miller <davem@davemloft.net>
In-Reply-To: <118457926823-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
	<118457926823-git-send-email-jens.axboe@oracle.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Mon, 16 Jul 2007 11:47:27 +0200

> This updates the sparc iommu/pci dma mappers to sg chaining.
> 
> Cc: davem@davemloft.net
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Acked-by: David S. Miller <davem@davemloft.net>
