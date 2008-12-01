Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYLAQgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYLAQgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYLAQgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:36:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbYLAQgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:36:39 -0500
Date: Mon, 1 Dec 2008 08:36:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [please, revert] Re: [PATCH 11/32] of_platform_driver noise on
 sparce
In-Reply-To: <20081130.231354.204449660.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0812010835080.3256@nehalem.linux-foundation.org>
References: <E1L3wNs-0006R4-JQ@ZenIV.linux.org.uk> <20081126.010541.158438052.davem@davemloft.net> <20081130212329.GF28946@ZenIV.linux.org.uk> <20081130.231354.204449660.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 30 Nov 2008, David Miller wrote:
> 
> It looks like all of your patches got applied regardless of
> what followups they received.
> 
> I'll chalk this up to a simple oversight given that Linus just
> got back from a week of vacation :)

Yes. But also to me simply being pretty much conditioned to applying Al's 
patches regardless (they often cross maintainer boundaries, and they are 
almost always correct). So even in the absense of vacation, it probably 
would have happened.

But it's reverted now.

			Linus
