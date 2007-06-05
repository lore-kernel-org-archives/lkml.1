Return-Path: <linux-kernel-owner+w=401wt.eu-S934086AbXFEXnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086AbXFEXnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760141AbXFEXnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:43:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45839
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758791AbXFEXnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:43:03 -0400
Date: Tue, 05 Jun 2007 16:43:17 -0700 (PDT)
Message-Id: <20070605.164317.78711072.davem@davemloft.net>
To: chrisw@sous-sol.org
Cc: simon@fire.lp0.eu, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       yoshfuji@linux-ipv6.org, berni@birkenwald.de, stable@kernel.org,
       linkfanel@yahoo.fr
Subject: Re: [stable] "[IPV6]: Fix routing round-robin locking." breaks
 manual default route (bug 8349)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070605233616.GF3723@sequoia.sous-sol.org>
References: <465B45E0.3040007@simon.arlott.org.uk>
	<20070605233616.GF3723@sequoia.sous-sol.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>
Date: Tue, 5 Jun 2007 16:36:16 -0700

> Rather than reverting that patch, applying this patch should fix
> your ipv6 issue:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=7ebba6d14f8d63cad583bf1cc0330b601d5a8171
> 
> I'll wait for Dave or Yoshifuji to decide if this is a proper -stable
> patch.

I have a batch of stuff to send to -stable tonight and I
will make sure that this will be part of it.

Thanks for reminding me.
