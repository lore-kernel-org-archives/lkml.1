Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbXKTGQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbXKTGQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368AbXKTGP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:15:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36187
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756297AbXKTGP6 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:15:58 -0500
Date: Mon, 19 Nov 2007 22:15:57 -0800 (PST)
Message-Id: <20071119.221557.88596881.davem@davemloft.net>
To: Linux-kernel@vger.kernel.org, mle+lk@mega-nerd.com
Subject: Re: BUG: soft lockup detected on CPU#0! in 2.6.23.8
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071120162225.c5006305.mle+lk@mega-nerd.com>
References: <20071120162225.c5006305.mle+lk@mega-nerd.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik de Castro Lopo <mle+lk@mega-nerd.com>
Date: Tue, 20 Nov 2007 16:22:25 +1100

> I've just compiled 2.6.23.8 from kernel.org sources and I getting a
> bunch of these soft lockups detected.

Yes, this is getting hit by everyone, a fix is in the works.
