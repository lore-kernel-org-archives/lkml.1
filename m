Return-Path: <linux-kernel-owner+w=401wt.eu-S1763854AbXGPAkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763854AbXGPAkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759923AbXGPAkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:40:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44303
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758288AbXGPAkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:40:11 -0400
Date: Sun, 15 Jul 2007 17:40:14 -0700 (PDT)
Message-Id: <20070715.174014.122618144.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix return type of skb_checksum_complete()
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1IAAGJ-00054e-Uk@ZenIV.linux.org.uk>
References: <E1IAAGJ-00054e-Uk@ZenIV.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 21:00:11 +0100

> 
> It returns __sum16, not unsigned int
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: David S. Miller <davem@davemloft.net>
