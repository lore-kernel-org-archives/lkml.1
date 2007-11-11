Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbXKKRvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbXKKRvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 12:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbXKKRvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 12:51:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43598 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755320AbXKKRvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 12:51:09 -0500
Date: Sun, 11 Nov 2007 09:50:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Robert Schwebel <r.schwebel@pengutronix.de>, Adrian Bunk <bunk@kernel.org>,
       Paul Mundt <lethal@linux-sh.org>, Sascha Hauer <s.hauer@pengutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netx: remove bogus defconfig patch with wrong -p
In-Reply-To: <20071111094111.GA12332@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.0.9999.0711110949340.30499@woody.linux-foundation.org>
References: <20071110080629.GA18520@linux-sh.org> <20071110091057.GA10446@flint.arm.linux.org.uk> <20071110112632.GQ8087@pengutronix.de> <20071110114953.GL26163@stusta.de> <20071110134048.GR8087@pengutronix.de> <20071110134154.GS8087@pengutronix.de>
 <20071111094111.GA12332@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Nov 2007, Russell King wrote:
>
> So what's happening with this?  Who's going to merge it?

Well, I already removed the bogus file. 

But whether the defconfig file in arch/arm needs updating or not is up to 
you guys.

		Linus
