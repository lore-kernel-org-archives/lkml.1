Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbXJCDBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbXJCDBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 23:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbXJCDBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 23:01:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54000
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754430AbXJCDBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 23:01:40 -0400
Date: Tue, 02 Oct 2007 20:01:39 -0700 (PDT)
Message-Id: <20071002.200139.36922966.davem@davemloft.net>
To: akepner@sgi.com
Cc: grundler@parisc-linux.org, jbarnes@virtuousgeek.org, jes@sgi.com,
       randy.dunlap@oracle.com, rdreier@cisco.com,
       James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dma: add dma_flags_set_attr() to dma interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071003024457.GF26752@sgi.com>
References: <20071003024457.GF26752@sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: akepner@sgi.com
Date: Tue, 2 Oct 2007 19:44:57 -0700

> 
> Introduce the dma_flags_set_attr() interface and give it a default 
> no-op implementation.
> 
> Signed-off-by: Arthur Kepner <akepner@sgi.com>

Acked-by: David S. Miller <davem@davemloft.net>
