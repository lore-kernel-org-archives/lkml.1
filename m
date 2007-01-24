Return-Path: <linux-kernel-owner+w=401wt.eu-S1030229AbXAXGFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030229AbXAXGFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 01:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030228AbXAXGFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 01:05:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54315
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030227AbXAXGFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 01:05:18 -0500
Date: Tue, 23 Jan 2007 22:05:17 -0800 (PST)
Message-Id: <20070123.220517.115910657.davem@davemloft.net>
To: bunk@stusta.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] process include/linux/if_{addr,link}.h with unifdef
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070121191319.GO9093@stusta.de>
References: <20070121191319.GO9093@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Sun, 21 Jan 2007 20:13:19 +0100

> After commit d3dcc077bf88806201093f86325ec656e4dbfbce, 
> include/linux/if_{addr,link}.h should be processed with unifdef.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Applied, thanks Adrian.

I believe at least the 2.6.19 -stable branch will need
this too, right?  Please submit to -stable as needed,
and feel free to add my sign-off:

Signed-off-by: David S. Miller <davem@davemloft.net>
