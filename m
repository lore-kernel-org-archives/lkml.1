Return-Path: <linux-kernel-owner+w=401wt.eu-S1763586AbYD3Wu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763586AbYD3Wu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYD3Wuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:50:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbYD3Wut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:50:49 -0400
Date: Wed, 30 Apr 2008 15:49:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: davem@davemloft.net, torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com, tglx@linutronix.de
Subject: Re: Slow DOWN, please!!!
Message-Id: <20080430154948.171686da.akpm@linux-foundation.org>
In-Reply-To: <20080430223509.GA31547@elte.hu>
References: <20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080430135405.ddc42075.akpm@linux-foundation.org>
	<20080430.142137.236846072.davem@davemloft.net>
	<20080430221936.GA27292@elte.hu>
	<20080430223509.GA31547@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 00:35:09 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> git-revert _kind of_ makes that possible too, but people still feel too 
> personal about reverts - they take it as intrusion into their subsystem 
> and regard it as an attack against their competence as a maintainer.

I'd question this.  People often seem pretty happy to yank their stuff out
of there - it relieves ongoing embarrassment and it relieves time pressure
- they can have another go and get it right at their leisure.

Of course, reverting is easy.  The hard part is often finding the thing
which needs to be reverted.

