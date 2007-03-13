Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbXCMAHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbXCMAHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 20:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbXCMAHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 20:07:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33838
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbXCMAHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 20:07:16 -0400
Date: Mon, 12 Mar 2007 17:07:15 -0700 (PDT)
Message-Id: <20070312.170715.112621117.davem@davemloft.net>
To: rpjday@mindspring.com
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Delete superfluous source file
 "net/wanrouter/af_wanpipe.c".
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0703100347290.24101@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703100347290.24101@CPE00045a9c397f-CM001225dbafb6>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Robert P. J. Day" <rpjday@mindspring.com>
Date: Sat, 10 Mar 2007 03:49:52 -0500 (EST)

> 
>   Delete the apparently superfluous source file
> net/wanrouter/af_wanpipe.c.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

Applied, thanks Robert.

This thing isn't even built in 2.4.x :-)  Although there is
some ancient reference to the build module in
Documentation/networking/wan-router.txt, a heavily out of date
document.
