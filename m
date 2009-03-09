Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZCIDCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZCIDCg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 23:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZCIDCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 23:02:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49151
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753413AbZCIDCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 23:02:22 -0400
Date: Sun, 08 Mar 2009 20:02:07 -0700 (PDT)
Message-Id: <20090308.200207.90768249.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-03-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090306212414.GG3712@tuxdriver.com>
References: <20090306212414.GG3712@tuxdriver.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 6 Mar 2009 16:24:14 -0500

> Here are a few small patches intended for 2.6.29.
> 
> Two of them add USB IDs to the Ralink drivers.  Some of those IDs are
> already in -next, so there will be some minor conflicts.
> 
> The one from Roel Kluin avoids checking for <0 on an unsigned variable.
> It seems like a very low-risk fix to a potentially hard to find
> problem, so it seems worthwhile to me.
> 
> The iwlwifi fix corrects some problems with cleaning-up after
> initialization errors, avoiding some potential resources leaks.
> 
> The p54 patch corrects a crash that was unveiled by applying a patch
> headed to -next.  The problem was their all along, so it seems work
> taking now.

Pulled, thanks a lot John.
