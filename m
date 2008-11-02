Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbYKBEi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbYKBEi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 00:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYKBEiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 00:38:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46534
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751637AbYKBEiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 00:38:17 -0400
Date: Sat, 01 Nov 2008 21:37:51 -0700 (PDT)
Message-Id: <20081101.213751.06182621.davem@davemloft.net>
To: jianjun@zeuux.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/2] nets: fix problem of return value
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081101101835.GG6556@ubuntu>
References: <20081101101835.GG6556@ubuntu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianjun Kong <jianjun@zeuux.org>
Date: Sat, 1 Nov 2008 18:18:35 +0800

> fix problem of return value
> 
> net/unix/af_unix.c: unix_net_init()
> when error appears, it should return 'error', not always return 0.
> 
> Signed-off-by: Jianjun Kong <jianjun@zeuux.org>

Applied, thank you.
