Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbXJCDCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbXJCDCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 23:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXJCDCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 23:02:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54009
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755113AbXJCDCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 23:02:05 -0400
Date: Tue, 02 Oct 2007 20:02:04 -0700 (PDT)
Message-Id: <20071002.200204.55511671.davem@davemloft.net>
To: akepner@sgi.com
Cc: grundler@parisc-linux.org, jbarnes@virtuousgeek.org, jes@sgi.com,
       randy.dunlap@oracle.com, rdreier@cisco.com,
       James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] dma: redefine dma_flags_set_attr() for sn-ia64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071003024641.GG26752@sgi.com>
References: <20071003024641.GG26752@sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: akepner@sgi.com
Date: Tue, 2 Oct 2007 19:46:41 -0700

> 
> define dma_flags_set_attr() for sn-ia64 - it "borrows" bits from 
> the direction argument (renamed "flags") to the dma_map_* routines 
> to pass an additional attributes.  Also define routines to retrieve 
> the original direction and attribute from "flags".
> 
> Signed-off-by: Arthur Kepner <akepner@sgi.com>

Acked-by: David S. Miller <davem@davemloft.net>
