Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbYAFHzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbYAFHzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 02:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbYAFHzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 02:55:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49976
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752686AbYAFHzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 02:55:39 -0500
Date: Sat, 05 Jan 2008 23:55:31 -0800 (PST)
Message-Id: <20080105.235531.155666649.davem@davemloft.net>
To: adrian.bunk@movial.fi
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [2.6.24 patch] fix netx-eth.c compilation
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080105214616.GE22232@does.not.exist>
References: <20080105214616.GE22232@does.not.exist>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <adrian.bunk@movial.fi>
Date: Sat, 5 Jan 2008 23:46:16 +0200

> This was missed when commit e2ac455a18806b31c2d0da0a51d8740af5010b7a 
> fixed the compile errors in drivers/net/netx-eth.c caused by
> commit 09f75cd7bf13720738e6a196cc0107ce9a5bd5a0.
> 
> Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

Applied, thanks Adrian.
