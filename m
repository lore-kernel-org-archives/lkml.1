Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbYKDCXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbYKDCXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 21:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYKDCXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 21:23:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33644
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbYKDCXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 21:23:43 -0500
Date: Mon, 03 Nov 2008 18:23:19 -0800 (PST)
Message-Id: <20081103.182319.103857163.davem@davemloft.net>
To: jianjun@zeuux.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] nets: remove two duplicated #include
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081103121908.GA24634@ubuntu>
References: <20081103121908.GA24634@ubuntu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianjun Kong <jianjun@zeuux.org>
Date: Mon, 3 Nov 2008 20:19:08 +0800

> 
> [PATCH] nets: remove two duplicated #include
> 
> Removed duplicated #include <rdma/ib_verbs.h> in net/9p/trans_rdma.c
> 		and  #include <linux/thread_info.h> in net/socket.c
> 
> Signed-off-by: Jianjun Kong <jianjun@zeuux.org>

Applied, thank you.
