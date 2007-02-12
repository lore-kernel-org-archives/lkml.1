Return-Path: <linux-kernel-owner+w=401wt.eu-S965327AbXBLURR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965327AbXBLURR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965361AbXBLURR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:17:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40022
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965327AbXBLURQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:17:16 -0500
Date: Mon, 12 Feb 2007 12:17:14 -0800 (PST)
Message-Id: <20070212.121714.41636131.davem@davemloft.net>
To: torvalds@osdl.org
Cc: kvarsin@gmail.com, netfilter-devel@lists.netfilter.org,
       netfilter@lists.netfilter.org, linux-kernel@vger.kernel.org,
       bunk@stusta.de
Subject: Re: 2.6.20-rc4: regression: iptables failed to load rules
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0701090929160.3594@woody.osdl.org>
References: <5157576d0701082329o1875911j20f6679e2d35bb17@mail.gmail.com>
	<Pine.LNX.4.64.0701090929160.3594@woody.osdl.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@osdl.org>
Date: Tue, 9 Jan 2007 09:33:32 -0800 (PST)

> David, please crack some heads.

I have some patches from Patrick in my queue which try to add some
sanity to this situation, we'll see how much better we can make it.
