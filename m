Return-Path: <linux-kernel-owner+w=401wt.eu-S933801AbXCZXtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbXCZXtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 19:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933811AbXCZXtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 19:49:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41295
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933801AbXCZXtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 19:49:16 -0400
Date: Mon, 26 Mar 2007 16:49:15 -0700 (PDT)
Message-Id: <20070326.164915.96684546.davem@davemloft.net>
To: rpjday@mindspring.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: dead CONFIG variables in kernel Makefiles
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0703261924470.26815@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703261924470.26815@CPE00045a9c397f-CM001225dbafb6>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Robert P. J. Day" <rpjday@mindspring.com>
Date: Mon, 26 Mar 2007 19:32:00 -0400 (EDT)

> 
>   the output from a short script i wrote, locating all CONFIG_
> variables in makefiles that don't appear to exist in any Kconfig file
> anywhere in the source tree.
> 
>   first, from the drivers/ directory:
> 
> ===== DRM_FFB =====
> ./drivers/char/drm/Makefile:obj-$(CONFIG_DRM_FFB)   += ffb.o

I'll take care of this one, thanks Robert.
