Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbXJ0Fxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbXJ0Fxb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 01:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXJ0FxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 01:53:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46805
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbXJ0FxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 01:53:21 -0400
Date: Fri, 26 Oct 2007 22:53:23 -0700 (PDT)
Message-Id: <20071026.225323.63281567.davem@davemloft.net>
To: jeff@garzik.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp v6: fix softnet build breakage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071027034240.GA13016@havoc.gtf.org>
References: <20071027034240.GA13016@havoc.gtf.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 26 Oct 2007 23:42:40 -0400

> 
> net/ipv6/tcp_ipv6.c: In function 'tcp_v6_rcv':
> net/ipv6/tcp_ipv6.c:1736: error: implicit declaration of function
> 'get_softnet_dma'
> net/ipv6/tcp_ipv6.c:1736: warning: assignment makes pointer from integer
> without a cast
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

Applied, thanks Jeff.
