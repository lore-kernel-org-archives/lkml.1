Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbXKQQkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbXKQQkc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 11:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXKQQkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 11:40:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40720 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbXKQQkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 11:40:24 -0500
Date: Sat, 17 Nov 2007 08:40:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 updates for 2.6.24
In-Reply-To: <alpine.LFD.0.9999.0711171723150.7601@localhost.localdomain>
Message-ID: <alpine.LFD.0.9999.0711170837150.4260@woody.linux-foundation.org>
References: <alpine.LFD.0.9999.0711171631320.7601@localhost.localdomain> <alpine.LFD.0.9999.0711171723150.7601@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 Nov 2007, Thomas Gleixner wrote:
> 
> Just added Sam's latest fix for the x86 build mechanism on top of the 
> patches below.

Heh. I applied it just before pulling, so it's there twice. Git obviously 
then merged it without problems, so I didn't even notice until you 
mentioned it (because the diffstat matched your original diffstat due to 
the new commit you added not actually causing any differences ;)

		Linus
