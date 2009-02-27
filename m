Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZB0Giz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZB0Giz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 01:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbZB0Gim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 01:38:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41091
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757338AbZB0Gil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 01:38:41 -0500
Date: Thu, 26 Feb 2009 22:38:25 -0800 (PST)
Message-Id: <20090226.223825.111184836.davem@davemloft.net>
To: kkeil@suse.de
Cc: snakebyte@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: [Patch] list usage cleanup in MISDN
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090216080521.GA22627@pingi.kke.suse.de>
References: <20090216080521.GA22627@pingi.kke.suse.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Keil <kkeil@suse.de>
Date: Mon, 16 Feb 2009 09:05:21 +0100

> Trivial cleanup, list_del(); list_add_tail() is equivalent
> to list_move_tail(). Semantic patch for coccinelle can be
> found at www.cccmz.de/~snakebyte/list_move_tail.spatch
> 
> Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
> Acked-by: Karsten Keil <kkeil@novell.com>

Applied, thanks.
