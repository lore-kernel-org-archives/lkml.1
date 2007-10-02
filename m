Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbXJBMF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbXJBMF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 08:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXJBMFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 08:05:49 -0400
Received: from twin.jikos.cz ([213.151.79.26]:59490 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbXJBMFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 08:05:48 -0400
Date: Tue, 2 Oct 2007 14:04:42 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Andi Kleen <ak@suse.de>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
In-Reply-To: <200710021121.36443.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0710021403150.1310@twin.jikos.cz>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org
 > <alpine.LRH.0.999.0710021019310.23586@www.tglx.de> <200710021121.36443.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Andi Kleen wrote:

> Yes I have ~100 patches for arch/x86_64, arch/i386 Should I just drop 
> them?

I asuume that Andrew is periodically pulling your queue into -mm, isn't 
he? If so, Thomas explicitly stated that -mm can be converted easily with 
just a few rejects, right?

-- 
Jiri Kosina
