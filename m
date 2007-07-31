Return-Path: <linux-kernel-owner+w=401wt.eu-S940259AbXGaBGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940259AbXGaBGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934367AbXGaBGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:06:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49866
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759422AbXGaBGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:06:11 -0400
Date: Mon, 30 Jul 2007 18:06:02 -0700 (PDT)
Message-Id: <20070730.180602.69409269.davem@davemloft.net>
To: bunk@stusta.de
Cc: mszeredi@suse.cz, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] net/unix/af_unix.c: make code static
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070729145852.GA16817@stusta.de>
References: <20070729145852.GA16817@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Sun, 29 Jul 2007 16:58:52 +0200

> The following code can now become static:
> - struct unix_socket_table
> - unix_table_lock
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Also applied, thanks a lot.
