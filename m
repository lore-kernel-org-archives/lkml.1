Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbYDHB2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbYDHB2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 21:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYDHB1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 21:27:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbYDHB1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 21:27:54 -0400
Date: Mon, 7 Apr 2008 18:26:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christian Kujau <lists@nerdbynature.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc8-git5: Reported regressions from 2.6.24
In-Reply-To: <alpine.DEB.1.10.0804080058070.14044@sheep.housecafe.de>
Message-ID: <alpine.LFD.1.00.0804071824590.2886@woody.linux-foundation.org>
References: <200804071459.35628.rjw@sisk.pl> <alpine.DEB.1.10.0804080058070.14044@sheep.housecafe.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Apr 2008, Christian Kujau wrote:
> 
> Q: Has a consensus been made already whether or not to release the next
>    kernel version with still pending/unresolved regressions?

Heh. We've always had some pending/unresolved issues, and I think that as 
out tracking gets better, there's likely to be more of them. A number of 
bug-reports are either hard to reproduce (often including from the 
reporter) or end up without updates etc.

So yes, I do end up releasing with pending issues, although I often try to 
get a gut feel for what kind of severity we're talking about and not 
release with *big* pending issues.

		Linus
