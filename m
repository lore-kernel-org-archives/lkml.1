Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbYGNVQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbYGNVQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYGNVQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:16:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33616 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbYGNVQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:16:37 -0400
Message-ID: <487BC220.2060401@zytor.com>
Date: Mon, 14 Jul 2008 14:16:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 changes for v2.6.27
References: <20080714135034.GA7013@elte.hu> <alpine.LFD.1.10.0807141346170.3305@woody.linux-foundation.org> <487BBDCB.7050303@zytor.com> <alpine.LFD.1.10.0807141359450.3305@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807141359450.3305@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> No. The default value should be 'off', unless it's _needed_ by people.
> 
> Have you guys looked at the size of the kernel lately?
> 
> Bloat is bloat. Just because it's conditional is not an excuse.
> 
> Having an in-kernel memory tester is in no way better than having an 
> out-of-kernel one that you pick at grub boot time, so the claim that it's 
> a "recommended" thing is likely bogus too. 
> 

Fair enough.

	-hpa
