Return-Path: <linux-kernel-owner+w=401wt.eu-S1161239AbXCGDoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161239AbXCGDoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 22:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161251AbXCGDoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 22:44:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46033 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161239AbXCGDoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 22:44:10 -0500
Date: Tue, 6 Mar 2007 19:43:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yinghai.lu@amd.com>
cc: ebiederm@xmission.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] x86_64 irq: keep consistent for changing IRQ0_VECTOR
 from 0x20 to 0x30
In-Reply-To: <86802c440703052359q3242f771ne9c10752613820d3@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703061942000.5963@woody.linux-foundation.org>
References: <86802c440703052359q3242f771ne9c10752613820d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Mar 2007, Yinghai Lu wrote:
>
> please check the patch

Hmm.. It doesn't look *wrong*, but could you please

 - split it up a bit (some of it is 100% obvious, ie the comment fixes)

 - write an explanation for the individually split up patches

 - not use attachments, but just make it inline. It's practically 
   impossible to reply and quote part of the patch now.

Eric/Ingo - did you go through and check the patch?

Thanks,

		Linus
