Return-Path: <linux-kernel-owner+w=401wt.eu-S934989AbXJQUWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934989AbXJQUWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934654AbXJQUWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:22:12 -0400
Received: from www.tglx.de ([62.245.132.106]:35565 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934609AbXJQUWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:22:11 -0400
Date: Wed, 17 Oct 2007 22:21:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nmi_watchdog on x86_64
In-Reply-To: <86802c440710151912n3b288dc4na06a9abb2addacf4@mail.gmail.com>
Message-ID: <alpine.LFD.0.9999.0710172220510.24155@localhost.localdomain>
References: <86802c440710151912n3b288dc4na06a9abb2addacf4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Oct 2007, Yinghai Lu wrote:

> just found my on hand ck804, and mcp55 based AMD servers:
> nmi_watchdog=1 doesn't work
> but nmi_watchdog=2 does work
> 
> =1, it say: IOAPIC 8259A virtual wire mode...
> 
> Did nmi_watchdog=1 work on any other amd64 platform?

I think I used it, but I don't remember when. Will try tomorrow.

  tglx
