Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbXGNGyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbXGNGyx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 02:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXGNGyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 02:54:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59184
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751891AbXGNGym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 02:54:42 -0400
Date: Fri, 13 Jul 2007 23:54:42 -0700 (PDT)
Message-Id: <20070713.235442.75191469.davem@davemloft.net>
To: bunk@stusta.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] cleanup congestion control options
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070714040953.GE3565@stusta.de>
References: <20070714040953.GE3565@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Sat, 14 Jul 2007 06:09:54 +0200

> This patch contains the following cleanups:
> - note in the prompt if an option depends on EXPERIMENTAL
> - remove "default n"s that didn't have any effect
> - remove "default m"s from options under TCP_CONG_ADVANCED:
>   if you manually choose congestion control modules you should
>   know which ones you want
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

I'm not so sure about any of this, sorry Adrian, I'm
not applying this.
