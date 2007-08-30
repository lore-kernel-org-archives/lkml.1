Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbXH3MJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbXH3MJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 08:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbXH3MJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 08:09:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4381 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbXH3MJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 08:09:34 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 08:09:34 EDT
X-AuthUser: davidel@xmailserver.org
Date: Thu, 30 Aug 2007 05:01:23 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, stable@kernel.org,
       Christoph Hellwig <hch@lst.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Revised timerfd() interface
In-Reply-To: <20070825064114.107820@gmx.net>
Message-ID: <Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
References: <20070825064114.107820@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2007, Michael Kerrisk wrote:

> Davide -- ping!  Can you please offer your comments about this change, and
> also thoughts on Jon's and my comments about a more radical API change
> later  in this thread.

IMO the complexity of the resulting API (and resulting patch), and the ABI 
change, is not justified by the added value.



- Davide


