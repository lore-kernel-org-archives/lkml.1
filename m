Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbYBRCdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbYBRCdE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 21:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYBRCcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 21:32:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44339
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbYBRCcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 21:32:54 -0500
Date: Sun, 17 Feb 2008 18:33:30 -0800 (PST)
Message-Id: <20080217.183330.34203930.davem@davemloft.net>
To: tilman@imap.cc
Cc: bunk@kernel.org, elendil@planet.nl, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Unable to continue testing of 2.6.25
From: David Miller <davem@davemloft.net>
In-Reply-To: <47B88A08.2070902@imap.cc>
References: <200802171025.30590.elendil@planet.nl>
	<20080217131611.GA1403@cs181133002.pp.htv.fi>
	<47B88A08.2070902@imap.cc>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Sun, 17 Feb 2008 20:24:56 +0100

> No, that's not the real problem. Even if the kernel didn't lack
> any required functionality and it could all be done today without
> VirtualBox, pulling the rug from underneath it like that leaves
> all those who are currently relying on it without the ability to
> continue testing newer kernels until they find the time to redesign
> their working environment.

No, it is VirtualBox's problem.  Nobody outside of the kernel
should be using that symbol, it can only be used for totally
unsupportable things as far as upstream is concerned.
