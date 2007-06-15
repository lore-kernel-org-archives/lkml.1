Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbXFOWQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbXFOWQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 18:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbXFOWQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 18:16:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34117
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752247AbXFOWP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 18:15:59 -0400
Date: Fri, 15 Jun 2007 15:16:18 -0700 (PDT)
Message-Id: <20070615.151618.28395619.davem@davemloft.net>
To: bunk@stusta.de
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [2.6 patch] net/rxrpc/ar-connection.c: fix NULL dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070615214513.GL3588@stusta.de>
References: <20070615214513.GL3588@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Fri, 15 Jun 2007 23:45:13 +0200

> This patch fixes a NULL dereference spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Looks good to me, patch applied, thanks Adrian.
