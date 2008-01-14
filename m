Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbYANGTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbYANGTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 01:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYANGT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 01:19:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49781
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbYANGT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 01:19:28 -0500
Date: Sun, 13 Jan 2008 22:19:27 -0800 (PST)
Message-Id: <20080113.221927.114540335.davem@davemloft.net>
To: kaber@trash.net
Cc: herbert@gondor.apana.org.au, viro@ZenIV.linux.org.uk,
       m.kozlowski@tuxland.pl, sparclinux@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sparc oops in ip_fast_csum
From: David Miller <davem@davemloft.net>
In-Reply-To: <478AFC92.50508@trash.net>
References: <20080106020214.GQ27894@ZenIV.linux.org.uk>
	<20080106041430.GA3784@gondor.apana.org.au>
	<478AFC92.50508@trash.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 14 Jan 2008 07:09:22 +0100

> But I agree to your suggestion, that will allow us to properly
> handle packets with IP options. I'll take care of this.

Thanks a lot Patrick.
